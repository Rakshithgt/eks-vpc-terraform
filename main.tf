terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }

    backend "s3" {
      bucket         = "demo-terraform-eks-state-bucket"
      key            = "terraform.tfstate"
      region         = "us-west-2"
      dynamodb_table = "terraform-eks-state-lock"
      encrypt         = true
    }
}


provider "aws" {
  region = "us-west-2"
  
}

module "vpc" {
  source              = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name
  availability_zones   = var.availability_zones
  
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  node_groups     = var.node_groups
}