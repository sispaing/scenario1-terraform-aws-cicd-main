variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-southeast-1"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "172.31.101.0/24"
}

variable "project_name" {
  description = "A unique name for the project to prefix resources."
  type        = string
  default     = "devops-assign"
}

# ADD this new variable instead
variable "public_key_content" {
  description = "The content of the public SSH key."
  type        = string
  # This variable is sensitive, but the value is not a secret.
  # Marking it sensitive prevents it from being shown in plan outputs.
  sensitive   = true
}