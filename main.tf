# ═══════════════════════════════════════════════════════════════
#   SIMPLE EC2 INSTANCE — Terraform
# ═══════════════════════════════════════════════════════════════

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


# ─── DATA: Get the latest Amazon Linux 2023 AMI ───────────────
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


# ─── SECURITY GROUP ───────────────────────────────────────────
resource "aws_security_group" "my_sg" {
  name        = "my-ec2-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-ec2-sg"
  }
}


# ─── EC2 INSTANCE ─────────────────────────────────────────────
resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.amazon_linux.i
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-ec2-server"
  }
}


# ─── OUTPUTS ──────────────────────────────────────────────────
output "instance_id" {
  value = aws_instance.my_server.id
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

output "public_dns" {
  value = aws_instance.my_server.public_dns
}
