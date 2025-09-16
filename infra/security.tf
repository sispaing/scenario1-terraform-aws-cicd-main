
# --- SSH Key Pair & Bastion ---
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key_content
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnets.public.ids[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  tags                        = { Name = "${var.project_name}-bastion-host" }
}