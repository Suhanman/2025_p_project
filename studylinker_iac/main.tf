# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"

#     #   kubernetes = {
#     #   source  = "hashicorp/kubernetes"
#     #   version = ">= 2.23"
#     # }
#     }
    
#   }
# }


# # provider "helm" {
# #   alias = "eks"
# #   kubernetes = {
# #     host                   = module.eks.cluster_endpoint
# #     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
# #     token                  = module.eks.cluster_token
# #   }
# # }


# provider "aws" {
#   region = "ap-northeast-2"
# }

# module "vpc" {
#   source = "./modules/vpc"
# }
# module "subnet" {
#   source = "./modules/subnet"
#   vpc_id = module.vpc.vpc_id
#   cluster_name=var.cluster_name
# }


# module "route" {
#   source = "./modules/route"
#   vpc_id = module.vpc.vpc_id
#   public_subnet_ids = module.subnet.public_subnet_ids
#   igw_id = module.igw.igw_id
#   nat_id = module.nat.nat_id
#   nat_network_interface_id = module.nat.nat_network_interface_id
#   private_subnet_ids = module.subnet.private_subnet_ids
# }

# module "igw" {
#   source = "./modules/igw"
#   vpc_id = module.vpc.vpc_id
# }

# module "nat" {
#   source                = "./modules/nat"
#   vpc_id                = module.vpc.vpc_id
#   public_subnet_ids     = module.subnet.public_subnet_ids
#   instance_type         = "t3.micro"
#   nat_sg_id = module.sg.nat_sg_id
# }

# module "sg"{
#   source = "./modules/sg"
#   vpc_id = module.vpc.vpc_id
#   private_subnet_ids = module.subnet.private_subnet_ids
  
# }

# module "db"{
#   source = "./modules/db"
#   public_subnet_ids_dbtest    = module.subnet.public_subnet_ids_dbtest
#   db_subnet_ids = module.subnet.db_subnet_ids
#   rds_sg_id = module.sg.rds_sg_id
#   instance_class    = var.instance_class
#   db_username          = var.db_username
#   db_password          = var.db_password

# }

# module "key"{
#   source = "./modules/key"
# }


# module "iam"{
#   source = "./modules/iam"
#   # eks_oidc_provider_arn=module.eks.eks_oidc_provider_arn
#   # eks_oidc_issuer_url=module.eks.eks_oidc_issuer_url

# }



# # module "eks"{
# #   source = "./modules/eks"
# #   private_subnet_ids = module.subnet.private_subnet_ids
# #   eks_control_sg_id=module.sg.eks_control_sg_id
# #   eks_node_sg_id=module.sg.eks_node_sg_id
# #   eks_cluster_role_arn=module.iam.eks_cluster_role_arn
# #   eks_node_role_arn=module.iam.eks_node_role_arn
# # }

# # data "aws_eks_cluster" "cluster" {
# #   name = var.cluster_name
# #    depends_on = [module.eks]
# # }
# # data "aws_eks_cluster_auth" "cluster" {
# #   name = var.cluster_name
# #   depends_on = [module.eks]
# # }
# # provider "kubernetes" {
# #   host                   = data.aws_eks_cluster.cluster.endpoint
# #   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
# #   token                  = data.aws_eks_cluster_auth.cluster.token
# # }

# # module "afteriam"{
# #   source = "./modules/afteriam"
# #   cluster_name=module.eks.cluster_name
# #   depends_on =[module.eks]
# #   eks_oidc_provider_arn=module.eks.eks_oidc_provider_arn
# #   eks_oidc_issuer_url=module.eks.eks_oidc_issuer_url
# # }

# # module "alb"{
# #   source = "./modules/alb"

# #    providers = {
# #     helm = helm.eks
# #   }
  
# #   cluster_name=module.eks.cluster_name
# #   cluster_endpoint=module.eks.cluster_endpoint
# #   cluster_token=module.eks.cluster_token
# #   cluster_certificate_authority_data=module.eks.cluster_certificate_authority_data
# #   vpc_id=module.vpc.vpc_id
# #   depends_on =[module.eks, module.iam]
# # }

# # module "configmap"{
# #   source = "./modules/configmap"
# #   eks_node_role_arn = module.iam.eks_node_role_arn
# #   depends_on =[module.eks, module.iam]
# # }




# # module "s3"{
# #   source = "./modules/s3"
# # }



# module "instance"{
#   source = "./modules/instance"
#   instance_type = var.instance_type
#   master_instance_type = var.master_instance_type
#   worker_instance_type = var.worker_instance_type
#   public_subnet_ids = module.subnet.public_subnet_ids
#   private_subnet_ids = module.subnet.private_subnet_ids
#   bastion_sg_id = module.sg.bastion_sg_id
#   master_node_sg_id = module.sg.k3s_master_sg_id
#   worker_node_sg_id = module.sg.k3s_worker_sg_id
#   bastion_instance_profile_name = module.iam.bastion_instance_profile_name
#   k3s_nodes_instance_profile_name = module.iam.k3s_nodes_instance_profile_name
#   ec2_key_name=module.key.ec2_key_name
#   bastion_key_name=module.key.bastion_key_name

#   depends_on=[
#     module.iam
#   ]
# }


