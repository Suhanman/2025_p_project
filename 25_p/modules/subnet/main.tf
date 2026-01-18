resource "aws_subnet" "public" {
  vpc_id     = var.vpc_id
  for_each                = {
    public-subnet-a = { cidr = "10.0.1.0/24", az = "ap-northeast-2a" }
    public-subnet-c  = { cidr = "10.0.2.0/24", az = "ap-northeast-2c" }
  }

   map_public_ip_on_launch = true
   cidr_block        = each.value.cidr
   availability_zone = each.value.az

  tags = {
    Name = each.key
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# resource "aws_subnet" "app_subnet" {
#   vpc_id     = var.vpc_id
#   cidr_block = "10.0.2.0/24"

#   availability_zone = "ap-northeast-2a"
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "app_subnet"
#   }
# }

resource "aws_subnet" "private" {
  for_each                = {
    private-subnet-a = { cidr = "10.0.11.0/24", az = "ap-northeast-2a" }
    private-subnet-c = { cidr = "10.0.12.0/24", az = "ap-northeast-2c" }
  }
  vpc_id     = var.vpc_id
  map_public_ip_on_launch = false
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-db" {
  for_each                = {
    db-subnet-a = { cidr = "10.0.21.0/24", az = "ap-northeast-2a" }
    db-subnet-c = { cidr = "10.0.22.0/24", az = "ap-northeast-2c" }
  }
  vpc_id     = var.vpc_id
  map_public_ip_on_launch = false
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}