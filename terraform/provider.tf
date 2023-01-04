terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
  backend "s3" {
    bucket = "upgrad-sneh"
    key    = "devops-project/tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
  region  = "us-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}