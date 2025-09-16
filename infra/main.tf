# --- ALB ---
resource "aws_lb" "public_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.public.ids
  tags               = { Name = "${var.project_name}-alb" }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# --- ASG & Launch Template ---
resource "aws_launch_template" "web_server" {
  name_prefix   = "${var.project_name}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  # Use the modern templatefile() function to render the user data script
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    s3_bucket_name = aws_s3_bucket.web_content.bucket
    aws_region     = var.aws_region
  }))

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name          = "${var.project_name}-web-server"
      # IMPORTANT: This path assumes your 'web-content' directory is at the root of your repo,
      # one level above the 'terraform' directory.
      WebAppVersion = filemd5("${path.module}/web-content/index.html")
    }
  }
}

resource "aws_autoscaling_group" "server_fleet_a" {
  name                = "${var.project_name}-asg"
  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  vpc_zone_identifier = [aws_subnet.private.id]
  target_group_arns   = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_server.id
    # Explicitly depend on the latest_version to help trigger the refresh
    version = aws_launch_template.web_server.latest_version 
  }

  # This block now automatically triggers a rolling update when the launch template changes
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 66
    }
    triggers = [
      "launch_template"
    ]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }
}