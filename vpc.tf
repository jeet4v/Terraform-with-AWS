#Step 1: Create a VPC
resource "aws_vpc" "VPC-Terraform" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-Terraform"
    name = var.tag-name
  }
}

#Step 2: Create a public subnet 1
resource "aws_subnet" "Public-Subnet-AZ-1" {
  vpc_id                  = aws_vpc.VPC-Terraform.id
  availability_zone       = var.availability_zone-1
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-AZ-1"
    name = var.tag-name
  }
}

#Step 2(b): Create a public subnet 2
resource "aws_subnet" "Public-Subnet-AZ-2" {
  vpc_id                  = aws_vpc.VPC-Terraform.id
  availability_zone       = var.availability_zone-2
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-AZ-2"
    name = var.tag-name
  }
}

#Step 3: create a private subnet 1
resource "aws_subnet" "Private-Subnet-AZ-1" {
  vpc_id            = aws_vpc.VPC-Terraform.id
  availability_zone = var.availability_zone-1
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "Private-Subnet-AZ-1"
    name = var.tag-name
  }
}

#Step 3(b): create a private subnet 2
resource "aws_subnet" "Private-Subnet-AZ-2" {
  vpc_id            = aws_vpc.VPC-Terraform.id
  availability_zone = var.availability_zone-2
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "Private-Subnet-AZ-2"
    name = var.tag-name
  }
}

#Step 4: create Internet Gateway (we will map this igw with public subnet only to access the internet)
resource "aws_internet_gateway" "igw-Terraform" {
  vpc_id = aws_vpc.VPC-Terraform.id
  tags = {
    Name = "igw-Terraform"
    name = var.tag-name
  }
}

#Step 5: create Route Tables for public subnet
resource "aws_route_table" "rt-Terraform" {
  vpc_id = aws_vpc.VPC-Terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-Terraform.id
  }
  tags = {
    Name = "rt-Terraform"
    name = var.tag-name
  }
}

#Step 6: Create route table association with public subnet 1
resource "aws_route_table_association" "rt-association-Terraform-Public-Subnet-AZ-1" {
  subnet_id      = aws_subnet.Public-Subnet-AZ-1.id
  route_table_id = aws_route_table.rt-Terraform.id
}

#Step 6(b): Create route table association with public subnet 2
resource "aws_route_table_association" "rt-association-Terraform-Public-Subnet-AZ-2" {
  subnet_id      = aws_subnet.Public-Subnet-AZ-2.id
  route_table_id = aws_route_table.rt-Terraform.id
}

#Step 7: Create security group (Firewall)
resource "aws_security_group" "sg-Terraform" {
  vpc_id      = aws_vpc.VPC-Terraform.id
  description = "Allow HTTPS to web server created through Terraform"
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "HTTPS egress created through Terraform"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "HTTPS ingress created through Terraform"
      from_port        = 3389
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3389
    }
  ]
  tags = {
    Name = "sg-Terraform"
    name = var.tag-name
  }
}