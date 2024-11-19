provider "aws" {
  region = "eu-central-1"
}

# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name               = "Sharanya-VPC"
  cidr               = "10.0.0.0/18"
   azs                = ["eu-central-1a"]
  public_subnets     = ["10.0.1.0/24"]
  private_subnets    = ["10.0.2.0/24"]

  public_subnet_tags = {
    Name = "Sharanya-PublicSubnet"
  }
  private_subnet_tags = {
    Name = "Sharanya-PrivateSubnet"
  }
  tags = {
    Name = "Sharanya-VPC"
  }
}

# Security Group Module
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = "Sharanya-SecurityGroup"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0" # String format instead of list
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "Sharanya-SecurityGroup"
  }
}

# Public EC2 Instance Module
module "public_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name           = "Sharanya-Public-Instance"
  ami            = "ami-0084a47cc718c111a"
  instance_type  = "t2.micro"
  subnet_id      = module.vpc.public_subnets[0]

  vpc_security_group_ids = [module.security_group.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = "Sharanya-Public-Ec2Instance"
  }
}

# Private EC2 Instance Module
module "private_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name           = "Sharanya-Private-Instance"
  ami            = "ami-0084a47cc718c111a"
  instance_type  = "t2.micro"
  subnet_id      = module.vpc.private_subnets[0]

  vpc_security_group_ids = [module.security_group.security_group_id]

  associate_public_ip_address = false

  tags = {
    Name = "Sharanya-Private-Ec2Instance"
  }
}
