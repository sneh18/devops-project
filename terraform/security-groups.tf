# Public Subnet Security Group
module "public-sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name = "public-sg-183"

  vpc_id = module.vpc.vpc_id
  
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "For allowing SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "For allowing HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "For allowing HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Allow all egress traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  
  tags = {
    Terraform = "true"
  }
}

# Private Subnet Security Group
module "private-sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name = "private-sg-183"

  vpc_id = module.vpc.vpc_id
  
   ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Allow ingress traffic only from VPC CIDR block"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Allow all egress traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  
  tags = {
    Terraform = "true"
  }
}

# Security Group for Bastion Instances
module "bastion-sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name = "bastion-sg-183"
  description = "Allow self ip to ssh into bastion."

  vpc_id = module.vpc.vpc_id

  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["${chomp(data.http.myip.body)}/32"]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Allow all egress traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Terraform = "true"
  }
}