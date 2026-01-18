variable "vpc_id"{
    type=string
}



variable "private_subnet_ids"{
  type = map(string)
}

variable "private_subnet_cidrs" {
  type = map(string)
  default = {
    "private-subnet-a" = "10.0.11.0/24"
    "private-subnet-b" = "10.0.12.0/24"
  }
}

variable "enable_vrrp" {
  type    = bool
  default = false
  description = "Enable VRRP for kube-vip/keepalived in control-plane"
}