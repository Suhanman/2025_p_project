resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.public_subnet_ids_dbtest

  tags = {
    Name = "RDS subnet group"
  }
}





resource "aws_db_instance" "mariadb_primary" {
  identifier              = "mariadb-primary"
  allocated_storage       = 20
  snapshot_identifier     = "p-project-snap" 
  instance_class          =  var.instance_class
  engine                  = "mariadb"
  engine_version          = "11.4.5"
  port                    = 3306

  availability_zone       = "ap-northeast-2a"
  multi_az                = false
  publicly_accessible     = true
  deletion_protection     = false
  skip_final_snapshot     = true

  username                = var.db_username
  password                = var.db_password
  
  

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.rds_sg_id]
  backup_retention_period = 7
  apply_immediately       = true
  tags = {
    Name        = "RDS-MariaDB-primary"
    Environment = "prod"
  }
}



