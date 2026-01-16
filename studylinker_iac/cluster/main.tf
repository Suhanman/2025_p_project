# 25_p/cluster/main.tf

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# network 스택의 state를 읽어오기
data "terraform_remote_state" "networks" {
  backend = "local"
  config = {
    path = "../networks/terraform.tfstate"
  }
}
module "nat" {
  source = "../modules/nat"

  vpc_id            = data.terraform_remote_state.networks.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.networks.outputs.public_subnet_ids

  instance_type = "t3.micro"

  nat_sg_id = data.terraform_remote_state.networks.outputs.nat_sg_id
}
module "route" {
  source = "../modules/route"

  vpc_id            = data.terraform_remote_state.networks.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.networks.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.networks.outputs.private_subnet_ids
  igw_id            = data.terraform_remote_state.networks.outputs.igw_id

  nat_id                  = module.nat.nat_id
  nat_network_interface_id = module.nat.nat_network_interface_id
}

module "key"{
  source = "../modules/key"
}

module "instance" {
  source = "../modules/instance"

  instance_type        = var.instance_type
  master_instance_type = var.master_instance_type
  worker_instance_type = var.worker_instance_type

  public_subnet_ids  = data.terraform_remote_state.networks.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.networks.outputs.private_subnet_ids

  bastion_sg_id     = data.terraform_remote_state.networks.outputs.bastion_sg_id
  master_node_sg_id = data.terraform_remote_state.networks.outputs.k3s_master_sg_id
  worker_node_sg_id = data.terraform_remote_state.networks.outputs.k3s_worker_sg_id

  # ⬇⬇⬇ 여기 두 줄만 교체
  bastion_instance_profile_name   = data.terraform_remote_state.networks.outputs.bastion_instance_profile_name
  k3s_nodes_instance_profile_name = data.terraform_remote_state.networks.outputs.k3s_nodes_instance_profile_name

  ec2_key_name     = module.key.ec2_key_name
  bastion_key_name = module.key.bastion_key_name

  # module.iam 은 이 스택에 없으니까 depends_on 도 제거
}
# module "db" {
#   source = "../modules/db"  # 또는 "../modules/db" (지금 main.tf 위치 기준으로 맞게 유지)

#   public_subnet_ids_dbtest = data.terraform_remote_state.networks.outputs.public_subnet_ids_dbtest
#   db_subnet_ids            = data.terraform_remote_state.networks.outputs.db_subnet_ids
#   rds_sg_id                = data.terraform_remote_state.networks.outputs.rds_sg_id

#   instance_class = var.instance_class
#   db_username    = var.db_username
#   db_password    = var.db_password
# }
