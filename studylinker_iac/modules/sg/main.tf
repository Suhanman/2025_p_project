resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS (MySQL)"
  vpc_id      = var.vpc_id

  # ⚠ 개발용: MySQL을 어디서나 열어둠 (0.0.0.0/0)
  ingress {
    description = "Allow MySQL from anywhere (DEV ONLY)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RDS → 밖으로 나가는 트래픽
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}



resource "aws_security_group" "nat_sg" {
  name        = "nat-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = values(var.private_subnet_cidrs)

  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Bastion host security group"
  vpc_id      = var.vpc_id

  # Ingress: SSH from anywhere (테스트용)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}






 //k3s 마스터 보안그룹
 resource "aws_security_group" "k3s_master_sg" {
   name        = "k3s-master-sg"
   description = "Security group for k3s master node"
   vpc_id      = var.vpc_id

   # SSH from bastion
   ingress {
     description      = "SSH from bastion"
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
     security_groups  = [aws_security_group.bastion_sg.id]
   }

   # egress: all
   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
     Name = "k3s-master-sg"
   }
 }

 resource "aws_security_group" "k3s_worker_sg" {
   name        = "k3s-worker-sg"
   description = "Security group for k3s worker nodes"
   vpc_id      = var.vpc_id

   # SSH from bastion
   ingress {
     description      = "SSH from bastion"
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
     security_groups  = [aws_security_group.bastion_sg.id]
   }

   # egress: all
   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
     Name = "k3s-worker-sg"
   }
 }

 # 🔄 worker → master : 모든 트래픽 허용
 resource "aws_security_group_rule" "worker_to_master_all" {
   type                     = "ingress"
   description              = "All traffic from worker nodes to master"
   from_port                = 0
   to_port                  = 0
   protocol                 = "-1"
   source_security_group_id = aws_security_group.k3s_worker_sg.id
   security_group_id        = aws_security_group.k3s_master_sg.id
 }

 # 🔄 master → worker : 모든 트래픽 허용
 resource "aws_security_group_rule" "master_to_worker_all" {
   type                     = "ingress"
   description              = "All traffic from master to worker nodes"
   from_port                = 0
   to_port                  = 0
   protocol                 = "-1"
   source_security_group_id = aws_security_group.k3s_master_sg.id
   security_group_id        = aws_security_group.k3s_worker_sg.id
 }








# # EKS 노드 그룹용 보안 그룹
# resource "aws_security_group" "eks_node_sg" {
#   name        = "eks-node-sg"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "eks-node-sg"
#   }
# }

# # EKS 컨트롤 플레인으로부터의 트래픽을 허용하는 인그레스 규칙
# resource "aws_security_group_rule" "allow_eks_control_plane_ingress" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   description       = "Allow EKS control plane to communicate with nodes"
#   source_security_group_id = aws_security_group.eks_control_sg.id
#   security_group_id = aws_security_group.eks_node_sg.id
# }

# # 노드 그룹 내 노드 간의 통신을 허용하는 인그레스 규칙
# resource "aws_security_group_rule" "allow_nodes_within_group_ingress" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "all"
#   source_security_group_id = aws_security_group.eks_node_sg.id
#   security_group_id = aws_security_group.eks_node_sg.id
# }

# # 노드가 외부 인터넷(예: ECR, S3)과 통신하기 위한 이그레스 규칙
# resource "aws_security_group_rule" "allow_all_egress" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks_node_sg.id
# }






# # # 2) Kubernetes API (6443) 
# resource "aws_security_group_rule" "cp_api_from_worker" {
#   type                     = "ingress"
#   from_port                = 6443
#   to_port                  = 6443
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.master_node_sg.id
#   source_security_group_id = aws_security_group.worker_node_sg.id
# }

# # 3) etcd peer (2379-2380) - self
# resource "aws_security_group_rule" "cp_etcd_peer" {
#   type                     = "ingress"
#   from_port                = 2379
#   to_port                  = 2380
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.master_node_sg.id
#   source_security_group_id = aws_security_group.master_node_sg.id
# }

# # 4) kubelet (10250)
# resource "aws_security_group_rule" "cp_kubelet_from_worker" {
#   type                     = "ingress"
#   from_port                = 10250
#   to_port                  = 10250
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.master_node_sg.id
#   source_security_group_id = aws_security_group.worker_node_sg.id
# }

# # 5) kubelet self (10250)
# resource "aws_security_group_rule" "cp_kubelet_self" {
#   type                     = "ingress"
#   from_port                = 10250
#   to_port                  = 10250
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.master_node_sg.id
#   source_security_group_id = aws_security_group.master_node_sg.id
# }

# # 6) controller-manager / scheduler (10257, 10259) - self
# resource "aws_security_group_rule" "cp_controller_mgr" {
#   type                     = "ingress"
#   from_port                = 10257
#   to_port                  = 10257
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.master_node_sg.id
#   source_security_group_id = aws_security_group.master_node_sg.id
# }

# resource "aws_security_group_rule" "cp_scheduler" {
#   type                     = "ingress"
#   from_port                = 10259
#   to_port                  = 10259
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.master_node_sg.id
#   source_security_group_id = aws_security_group.master_node_sg.id
# }

# # 7) Optional VRRP (112) - self
# resource "aws_security_group_rule" "cp_vrrp" {
#   count                     = var.enable_vrrp ? 1 : 0
#   type                      = "ingress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = "112"
#   security_group_id         = aws_security_group.master_node_sg.id
#   source_security_group_id  = aws_security_group.master_node_sg.id
# }

# #마스터노드 보안그룹 끝

# resource "aws_security_group" "worker_node_sg" {
#   name   = "worker-node-sg"
#   vpc_id = var.vpc_id

#   tags = {
#     "Name" = "k8s-worker-node-sg"
#   }
# }


# # 아웃바운드 전체 허용
# resource "aws_security_group_rule" "worker_egress_all" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.worker_node_sg.id
# }

# # SSH (22) from Bastion
# resource "aws_security_group_rule" "worker_ssh_from_bastion" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.worker_node_sg.id
#   source_security_group_id = aws_security_group.bastion_sg.id
# } 

# # Kubelet (10250) from master
# resource "aws_security_group_rule" "worker_kubelet_from_master" {
#   type                     = "ingress"
#   from_port                = 10250
#   to_port                  = 10250
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.worker_node_sg.id
#   source_security_group_id = aws_security_group.master_node_sg.id
# }

# # Kubernetes API (6443) to master
# resource "aws_security_group_rule" "worker_api_to_master" {
#   type                     = "ingress"
#   from_port                = 6443
#   to_port                  = 6443
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.worker_node_sg.id
#   source_security_group_id = aws_security_group.master_node_sg.id
# }

# # NodePort Services (30000–32767) - Optional
# resource "aws_security_group_rule" "worker_nodeport" {
#   type              = "ingress"
#   from_port         = 30000
#   to_port           = 32767
#   protocol          = "tcp"
#   security_group_id = aws_security_group.worker_node_sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# # Worker-to-Worker all traffic
# resource "aws_security_group_rule" "worker_self_all" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.worker_node_sg.id
#   source_security_group_id = aws_security_group.worker_node_sg.id
# }
# # 워커 노드 보안그룹 끝




















# # resource "aws_security_group" "nat_sg" {
# #   name        = "nat-sg"
# #   description = "Allow NAT instance traffic"
# #   vpc_id      = var.vpc_id

# #   ingress {
# #     description = "Allow all inbound (internal use)"
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   egress {
# #     description = "Allow all outbound"
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# # }
