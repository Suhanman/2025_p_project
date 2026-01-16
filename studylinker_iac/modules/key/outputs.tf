output "ec2_key_name" {
  description = "EC2 Key Pair Name"
  value       = aws_key_pair.ec2_key.key_name
}

output "ec2_key_public" {
  description = "Public key for EC2"
  value       = tls_private_key.ec2_key.public_key_openssh
}

output "private_key_local_file" {
  description = "Local path to the private key file"
  value       = local_file.private_key.filename
}

output "bastion_key_name" {
  value       = aws_key_pair.bastion_key.key_name
}

output "bastion_key_public" {
  value       = tls_private_key.bastion_key.public_key_openssh
}

output "bastion_private_key_local_file" {
  description = "Local path to the private key file"
  value       = local_file.bastion_private_key.filename
}