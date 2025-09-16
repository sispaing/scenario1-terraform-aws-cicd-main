# --- Terraform Configuration to Create the S3 Backend Bucket ---

variable "aws_region" {
  description = "The AWS region to create the S3 bucket in."
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "A unique name for the project to prefix the bucket."
  default     = "devops-assign"
}