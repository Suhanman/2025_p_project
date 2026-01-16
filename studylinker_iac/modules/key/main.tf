resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key.pem"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key"{
    content = tls_private_key.ec2_key.private_key_pem
    filename        = "C:\\Users\\victo\\.ssh\\ec2_key.pem"
    file_permission = "0600"
}


resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key.pem"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "local_file" "bastion_private_key"{
    content = tls_private_key.bastion_key.private_key_pem
    filename        = "C:\\Users\\victo\\.ssh\\bastion_key.pem"
    file_permission = "0600"
}



