output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.public_alb.dns_name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for web content."
  value       = aws_s3_bucket.web_content.bucket
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group."
  value       = aws_autoscaling_group.server_fleet_a.name
}

output "bastion_public_ip" {
  description = "Public IP address of the Bastion Host."
  value       = aws_instance.bastion.public_ip
}