output "bastion_instance_profile_name"{
    value = aws_iam_instance_profile.bastion_profile.name

}

output "k3s_nodes_instance_profile_name"{
    value = aws_iam_instance_profile.k3s_nodes_instance_profile.name

}

# output "eks_cluster_role_arn"{

#     value = aws_iam_role.eks_cluster_role.arn
# }
# output "eks_node_role_arn"{

#      value = aws_iam_role.eks_node_role.arn
# }

# # Output
# output "externaldns_irsa_role_arn" {
#   description = "IAM Role ARN for ExternalDNS IRSA"
#   value       = aws_iam_role.externaldns.arn
# }