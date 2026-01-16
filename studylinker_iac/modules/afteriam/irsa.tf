
data "aws_eks_cluster" "cluster" {
  name       = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name       = var.cluster_name
}

# -------------------------
# OIDC Provider
# -------------------------
data "tls_certificate" "oidc" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}



# -------------------------
# ALB Controller IAM Policy 로드
# -------------------------
resource "aws_iam_policy" "alb_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  path   = "/"
  policy = file("${path.module}/alb_ingress_iam_policy.json")
}

# -------------------------
# IAM Role for Service Account (IRSA)
# -------------------------

locals {
  oidc_host = replace(var.eks_oidc_issuer_url, "https://", "")
}

data "aws_iam_policy_document" "alb_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    # aud는 정확히 sts.amazonaws.com 이어야 함
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    # sub는 대상 SA에 매칭 (여기서는 kube-system/aws-load-balancer-controller)
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}


resource "aws_iam_role" "alb_irsa_role" {
  name               = "alb-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  role       = aws_iam_role.alb_irsa_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

# -------------------------
# Kubernetes ServiceAccount에 IAM Role 연결
# -------------------------
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_irsa_role.arn
    }
  }
  depends_on = [aws_iam_role_policy_attachment.alb_policy_attach]
}



