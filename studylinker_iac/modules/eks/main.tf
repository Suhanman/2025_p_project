resource "aws_eks_cluster" "studylink_eks" {
  name     = "studylink-eks"
  role_arn = var.eks_cluster_role_arn
  

  vpc_config {
    subnet_ids              = values(var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [var.eks_control_sg_id]
  }

 
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.studylink_eks.name
}
data "tls_certificate" "oidc" {
  url = aws_eks_cluster.studylink_eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.studylink_eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}



resource "aws_eks_node_group" "eks_node" {
  cluster_name = aws_eks_cluster.studylink_eks.name  

  node_group_name = "eks-node-group"
  node_role_arn   = var.eks_node_role_arn

 
  subnet_ids = values(var.private_subnet_ids)

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name = "eks-node"
  }


  depends_on = [
    aws_eks_cluster.studylink_eks
  ]
}
