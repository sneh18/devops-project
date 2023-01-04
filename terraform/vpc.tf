# Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "vpc-183"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.18.0/24", "10.0.19.0/24"]
  private_subnets = ["10.0.25.0/24", "10.0.26.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
  }
  public_subnet_tags = {
    Type = "Devops Project Public Subnets"
  }
  private_subnet_tags = {
    Type = "Devops Project Private Subnets"
  }
}