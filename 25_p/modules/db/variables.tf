variable "db_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids_dbtest" {
  type = list(string)
}
  
variable "rds_sg_id" {
  type = string
}



variable "instance_class" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
