# Bastion Instance in VPC Public Subnet
module "bation-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion"
  ami = "ami-0b93ce03dcbcb10f6"
  instance_type = "t2.small"
  key_name = "devops_project_key_pair"
  subnet_id  = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.bastion-sg.security_group_id]
  tags = {
    Terraform = "true"
  }
}

# Application Instance in VPC Private Subnet
module "app-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "app"
  ami = "ami-0b93ce03dcbcb10f6"
  instance_type = "t2.small"
  key_name = "devops_project_key_pair"
  subnet_id = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.private-sg.security_group_id]
  tags = {
    Terraform = "true"
  }
}

# Jenkins Instance in VPC Private Subnet
module "jenkins-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins"
  ami = "ami-0b93ce03dcbcb10f6"
  instance_type = "t2.small"
  key_name = "devops_project_key_pair"
  subnet_id  = module.vpc.private_subnets[1]
  vpc_security_group_ids = [module.private-sg.security_group_id]
  tags = {
    Terraform = "true"
  }
}