variable "instance_class" {
  type        = string
  default     = "db.t3.micro"  
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"  
}

variable "db_username" {
  type        = string
  default     = "admin"
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "cluster_name"{
    type=string
}


variable "master_instance_type" {
  type        = string
  description = "k3s master EC2 instance type"
  default     = "t3.small" # 필요하면 기본값, 아니면 빼도 됨
}

variable "worker_instance_type" {
  type        = string
  description = "k3s worker EC2 instance type"
  default     = "t3.large"
}
