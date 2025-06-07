variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key for EC2"
}

variable "project_name" {
  default = "notes-app"
}
