#EC2
variable "ami_id {
    type = string
    default = "ami-03695d52fod883f65"
}
variable "instance_type" {
    type = string
    default = "m5d.large"
}
variable "instance_tags" {
    type = map(string)
    default = {
        Name = "aws-dev-instance"
        Env = "Dev"
    }
}

#VPC
variable "cidr_block"{
    type = number
    default = 10.0.0.0/16
}
variable "vpc_tags" {
    type = map(string)
    default = {
        Name = "aws-dev-vpc"
        Env = "Dev"
    }
}
variable "az"{
    type = list
    default = ["ap-south-1a", "ap-south-1b"]
}
variable "public_subnet_cidr" {
  type = list
  validation {
    condition     = length(var.public_subnet_cidr) == 2
    error_message = "Please provide 2 public subnet CIDR"
  }
}
variable "private_subnet_cidr" {
  type = list
  validation {
    condition     = length(var.private_subnet_cidr) == 2
    error_message = "Please provide 2 private subnet CIDR"
  }
}

#front_end

variable "project_name" {
  default = "fintech"
}

variable "env" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "fintech"
    Component = "web-alb"
    Environment = "DEV"
    Terraform = "true"
  }
}
#Security_group

variable "sg_name"{
    type = string
    default = aws-vpc-sg-http-https
}
varible "allowed_ssh_cidr" {
    type = list(string)
    default = ["0.0.0.0/0]
}
variable "allowed_http_cidr" {
  type        = list(string)
  default = ["0.0.0.0/0]
}
variable "allowed_https_cidr" {
  type        = list(string)
  default = ["0.0.0.0/0]
}

#Database_Postgresql

variable "db_name" {
  type        = string
  default     = "DB_8byte_postgressql
}

variable "engine" {
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  default     = "latest"
}

variable "instance_class" {
  type        = string
  default     = "db.t5.medium"
}

variable "allocated_storage" {
  type        = number
  default     = 50
}

variable "db_username" {
  type        = string
  default     = "Admin"
}

variable "db_password" {
  type        = string
  sensitive   = true
  default     = "Password"
}

variable "subnet_ids" {
  type        = list(string)
  default     = ["10.0.31.0/24", "10.0.41.0/24"]
}

variable "security_group_ids" {
  type        = list(string)
}

variable "multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
}

variable "environment" {
  description = "Environment name"
  type        = string
}