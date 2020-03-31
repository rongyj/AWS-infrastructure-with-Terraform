
variable "aws_region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "ami" {
  description = "free ubuntu"
  default     = "ami-006a0174c6c25ac06"
}

variable "key_name" {
  default = "DEMO_KEY"
}
