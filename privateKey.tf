resource "tls_private_key" "Private_Key_RSA_Algorithm" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-Terraform" {
  key_name   = var.key-name
  public_key = tls_private_key.Private_Key_RSA_Algorithm.public_key_openssh
  tags = {
    Name = "key-Terraform"
    name = var.tag-name
  }
}

resource "local_file" "Terraform_VM_Key_File" {
  content  = tls_private_key.Private_Key_RSA_Algorithm.private_key_pem
  filename = "${var.key-name}.pem"
}
