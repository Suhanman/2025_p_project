output "rds_sg_id"{
    value=aws_security_group.rds_sg.id
}

output "nat_sg_id"{
    value=aws_security_group.nat_sg.id
}

output "bastion_sg_id"{
    value=aws_security_group.bastion_sg.id
}

# output "eks_control_sg_id" {
#   value       = aws_security_group.eks_control_sg.id
# }

# output "eks_node_sg_id" {
#   value       = aws_security_group.eks_node_sg.id
# }

# output "k3s_master_sg_id" {
#   description = "Security group ID for k3s master node"
#   value       = aws_security_group.k3s_master_sg.id
# }

# output "k3s_worker_sg_id" {
#   description = "Security group ID for k3s worker nodes"
#   value       = aws_security_group.k3s_worker_sg.id
# }


