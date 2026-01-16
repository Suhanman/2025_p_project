# cores/outputs.tf 예시

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnet.private_subnet_ids
}

output "igw_id" {
  value = module.igw.igw_id
}

output "bastion_sg_id" {
  value = module.sg.bastion_sg_id
}

# output "k3s_master_sg_id" {
#   value = module.sg.k3s_master_sg_id
# }

# output "k3s_worker_sg_id" {
#   value = module.sg.k3s_worker_sg_id
# }

output "nat_sg_id" {
  value = module.sg.nat_sg_id
}
# cores/outputs.tf

output "bastion_instance_profile_name" {
  value = module.iam.bastion_instance_profile_name
}

output "k3s_nodes_instance_profile_name" {
  value = module.iam.k3s_nodes_instance_profile_name
}
# cores/outputs.tf

output "public_subnet_ids_dbtest" {
  value = module.subnet.public_subnet_ids_dbtest
}

output "db_subnet_ids" {
  value = module.subnet.db_subnet_ids
}

output "rds_sg_id" {
  value = module.sg.rds_sg_id
}
