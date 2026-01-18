variable "public_subnet_ids" {
  type = map(string)
}


variable "vpc_id"{
    type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "nat_sg_id"{
    type    = string
}
