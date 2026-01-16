output "cluster_name" {
  value = aws_eks_cluster.studylink_eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.studylink_eks.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.studylink_eks.certificate_authority[0].data
}

output "cluster_token" {
  value     = data.aws_eks_cluster_auth.this.token
  sensitive = true
}

output "eks_oidc_provider_arn" {
  description = "OIDC Provider ARN for IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "eks_oidc_issuer_url" {
  description = "OIDC Issuer URL"
  value       = aws_eks_cluster.studylink_eks.identity[0].oidc[0].issuer
}