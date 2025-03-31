resource "aws_instance" "Public-VM-AZ-1-Terraform" {
  ami                         = var.ami
  instance_type               = var.instance-type
  key_name                    = var.key-name
  availability_zone           = var.availability_zone-1
  subnet_id                   = aws_subnet.Public-Subnet-AZ-1.id
  vpc_security_group_ids      = [aws_security_group.sg-Terraform.id]
  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }
  tags = {
    Name = "Public-VM-AZ-1-Terraform"
    name = var.tag-name
  }
}

resource "aws_instance" "Private-VM-AZ-1-Terraform" {
  ami                         = var.ami
  instance_type               = var.instance-type
  key_name                    = var.key-name
  availability_zone           = var.availability_zone-1
  subnet_id                   = aws_subnet.Private-Subnet-AZ-1.id
  vpc_security_group_ids      = [aws_security_group.sg-Terraform.id]
  associate_public_ip_address = false
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }
  tags = {
    Name = "Private-VM-AZ-1-Terraform"
    name = var.tag-name
  }
}

resource "aws_instance" "Private-VM-AZ-2-Terraform" {
  ami                         = var.ami
  instance_type               = var.instance-type
  key_name                    = var.key-name
  availability_zone           = var.availability_zone-2
  subnet_id                   = aws_subnet.Private-Subnet-AZ-2.id
  vpc_security_group_ids      = [aws_security_group.sg-Terraform.id]
  associate_public_ip_address = false
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }
  tags = {
    Name = "Private-VM-AZ-2-Terraform"
    name = var.tag-name
  }
}