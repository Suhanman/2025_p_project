variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "bastion_sg_id" {
  type    = string
}



variable "public_subnet_ids" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = map(string)
}



variable "ec2_key_name"{
  type = string
}

variable "bastion_key_name"{
  type = string
}

variable "bastion_instance_profile_name"{
  type=string
}

variable "k3s_nodes_instance_profile_name"{
  type=string
}

variable "master_instance_type" {
  type        = string
  default     = "t3.small"
  description = "Kubernetes master node instance type"
}

variable "worker_instance_type" {
  type        = string
  default     = "t3.large"
  description = "Kubernetes worker node instance type"
}
variable "master_node_sg_id" {
  type        = string
  description = "Security group ID for k3s master node"
}

variable "worker_node_sg_id" {
  type        = string
  description = "Security group ID for k3s worker nodes"
}