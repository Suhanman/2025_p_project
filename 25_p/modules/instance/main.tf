# resource "aws_launch_template" "bastion_template" {
#   name_prefix = "bastionami-"

#   image_id = "ami-0653cf5ff2685bc67"  
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "bastionami"
#     }
#   }
  
# }


resource "aws_instance" "bastion" {
  ami                         = "ami-087cb4927748e0457"
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids["public-subnet-a"]
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.bastion_instance_profile_name
  key_name                    = var.bastion_key_name

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "kubernetes-master" {
  ami                         = "ami-05ea60b5e8bb90318"
  instance_type               = var.master_instance_type 
  subnet_id                   = var.private_subnet_ids["private-subnet-a"]
  vpc_security_group_ids      = [var.master_node_sg_id]
  associate_public_ip_address = false
  key_name                    = var.ec2_key_name
  iam_instance_profile = var.k3s_nodes_instance_profile_name

  private_ip = "10.0.11.111"

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  tags = {
    Name = "kubernetes-master"
  }
}

resource "aws_instance" "kubernetes-worker" {
  ami                        = "ami-0b7759bae72a3b487"
  instance_type               = var.worker_instance_type
  subnet_id                   = var.private_subnet_ids["private-subnet-a"]
  vpc_security_group_ids      = [var.worker_node_sg_id]
  associate_public_ip_address = false
  key_name                    = var.ec2_key_name
  iam_instance_profile = var.k3s_nodes_instance_profile_name
  
  private_ip = "10.0.11.187"

   metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  tags = {
    Name = "kubernetes-worker"
  }
}




