variable "eks_control_sg_id"{
    type=string
}

variable "eks_node_sg_id"{
    type=string
}

variable "private_subnet_ids" {
  type = map(string)
}

variable "eks_cluster_role_arn"{
    type=string
}

variable "eks_node_role_arn"{
    type=string
}




