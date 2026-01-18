# # ExternalDNS IAM Policy
# data "aws_iam_policy_document" "externaldns" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "route53:ChangeResourceRecordSets"
#     ]
#     resources = [
#       # 필요하면 특정 Hosted Zone ARN으로 제한
#       "arn:aws:route53:::hostedzone/*"
#     ]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "route53:ListHostedZones",
#       "route53:ListResourceRecordSets",
#       "route53:ListTagsForResources"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "externaldns" {
#   name   = "AllowExternalDNSUpdates"
#   policy = data.aws_iam_policy_document.externaldns.json
# }

# # IRSA Trust Policy
# data "aws_iam_policy_document" "externaldns_trust" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [var.eks_oidc_provider_arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(var.eks_oidc_issuer_url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:external-dns"]
#     }
#   }
# }

# resource "aws_iam_role" "externaldns" {
#   name               = "external-dns-irsa"
#   assume_role_policy = data.aws_iam_policy_document.externaldns_trust.json
# }

# resource "aws_iam_role_policy_attachment" "externaldns_attach" {
#   role       = aws_iam_role.externaldns.name
#   policy_arn = aws_iam_policy.externaldns.arn
# }