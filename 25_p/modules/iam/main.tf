resource "aws_iam_role" "bastion_role" {
  name = "bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "bastion_inline_policy" {
  name        = "bastion-inline-policy"
  description = "Access to EKS and private Helm S3 repo"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
         {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        
        Resource = [
          "arn:aws:s3:::lovebridge-helm-chart-bucket",
          "arn:aws:s3:::lovebridge-helm-chart-bucket/*"
        ]
      }
    ]
  })
}

# 정책 붙이기
resource "aws_iam_role_policy_attachment" "bastion_policy_attach" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_inline_policy.arn
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_core" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}


resource "aws_iam_role" "k3s_nodes_role" {
  name = "k3s-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 1. CloudWatch를 읽을 수 있는 권한(Policy) 정의
resource "aws_iam_policy" "cloudwatch_read_only" {
  name        = "k3s-cloudwatch-reader-policy"
  description = "Allow K3s nodes to scrape CloudWatch metrics"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadingMetrics"
        Effect = "Allow"
        Action = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowReadingTags"
        Effect = "Allow"
        Action = "tag:GetResources"
        Resource = "*"
      }
    ]
  })
}

# 2. 위에서 만든 권한을 기존 Role(k3s_nodes_role)에 부착
resource "aws_iam_role_policy_attachment" "attach_cw_read" {
  role       = aws_iam_role.k3s_nodes_role.name  # 사용자님의 Role 이름 참조
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}

resource "aws_iam_policy" "alb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy-k3s"
  description = "Policy for AWS Load Balancer Controller on k3s"

  policy = file("${path.module}/aws-load-balancer-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_to_nodes" {
  role       = aws_iam_role.k3s_nodes_role.name
  policy_arn = aws_iam_policy.alb_controller.arn
}


resource "aws_iam_instance_profile" "k3s_nodes_instance_profile" {
  name = "k3s-nodes-instance-profile"
  role = aws_iam_role.k3s_nodes_role.name
}

# #eks role
# resource "aws_iam_role" "eks_cluster_role" {
#   name = "eks-cluster-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
# }

# EKS 노드 그룹 IAM 역할
# ----------------------------------------------------
# resource "aws_iam_role" "eks_node_role" {
#   name = "eks-node-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # EKS 노드 역할에 관리형 정책 연결
# resource "aws_iam_role_policy_attachment" "worker_node_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# # EKS CNI 정책 연결 (네트워크 인터페이스 관리)
# resource "aws_iam_role_policy_attachment" "cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# # Amazon ECR 읽기 전용 정책 연결 (컨테이너 이미지 접근)
# resource "aws_iam_role_policy_attachment" "registry_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }
