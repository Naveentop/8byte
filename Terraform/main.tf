# EC2_Instance
resource "aws_instance" "byte_instance" {
    ami_id = var.ami_id
    instance_type = var.instance_type
    vpc_id = aws_vpc.main.id
    security_group_id = 
    tag = var.instance_tags
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.vpc_tags
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_tags}-public-subnet"
  }
}

# Private subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_tags}-private-subnet"
  }
}

# front_end

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  tags = var.common_tags
}

resource "aws_acm_certificate" "8byte" {
  domain_name       = "8byte.online"
  validation_method = "DNS"
  tags = var.common_tags
}

data "aws_route53_zone" "8byte" {
  name         = "8byte.online"
  private_zone = false
}

resource "aws_route53_record" "8byte" {
  for_each = {
    for dvo in aws_acm_certificate.8byte.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.8byte.zone_id
}

resource "aws_acm_certificate_validation" "8byte" {
  certificate_arn         = aws_acm_certificate.8byte.arn
  validation_record_fqdns = [for record in aws_route53_record.8byte : record.fqdn]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.joindevops.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is the fixed response from Web ALB HTTPS"
      status_code  = "200"
    }
  }
}

# Security group

resource "aws_security_group" "aws_8byte_sg" {
  name        = var.sg_name
  description = "Security group for application"
  vpc_id      = aws_vpc.main.id

  # Inbound rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }
   ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }
  # Outbound rule
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# DB_subnet

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

#SG_postgres

resource "aws_security_group" "postgres_sg" {
  name        = "postgres-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.main.id

  # Inbound rule: PostgreSQL (port 5432)
  ingress {
    description     = "Allow PostgreSQL from app servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.app_security_group_ids
  }

  # Outbound rule
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "postgres-sg"
    Environment = var.environment
  }
}
# Database_Postgresql

resource "aws_db_instance" "rds_postgressql" {
  identifier              = var.db_name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage

  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = aws_security_group.postgres_sg.id

  publicly_accessible     = false
  multi_az                = var.az

  skip_final_snapshot     = true

  tags = {
    Name        = var.db_name
    Environment = var.environment
  }
}