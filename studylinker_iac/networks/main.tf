terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"

    #   kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = ">= 2.23"
    # }
    }
    
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "../modules/vpc"
}
module "subnet" {
  source = "../modules/subnet"
  vpc_id = module.vpc.vpc_id
  cluster_name=var.cluster_name
}
module "igw" {
  source = "../modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "sg"{
  source = "../modules/sg"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.subnet.private_subnet_ids
  
}

module "iam"{
  source = "../modules/iam"
  # eks_oidc_provider_arn=module.eks.eks_oidc_provider_arn
  # eks_oidc_issuer_url=module.eks.eks_oidc_issuer_url

}