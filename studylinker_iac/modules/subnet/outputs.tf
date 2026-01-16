output "public_subnet_ids" {
  value = {
    public-subnet-a = aws_subnet.public["public-subnet-a"].id
    public-subnet-c = aws_subnet.public["public-subnet-c"].id
  }
}

output "public_subnet_ids_dbtest" {
  value = [
    aws_subnet.public["public-subnet-a"].id,
    aws_subnet.public["public-subnet-c"].id
  ]
}


output "private_subnet_ids" {
  value = {
    private-subnet-a = aws_subnet.private["private-subnet-a"].id
    private-subnet-c = aws_subnet.private["private-subnet-c"].id
  }
}
output "db_subnet_ids" {
  value = [
    aws_subnet.private-db["db-subnet-a"].id,
    aws_subnet.private-db["db-subnet-c"].id
  ]
}
