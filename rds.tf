#Step 1: Create MS SQL Server Database instance
resource "aws_db_instance" "MS-SQL-DB-Terraform" {
  identifier             = "ms-sql-db-terraform"
  engine                 = "sqlserver-ex"
  instance_class         = "db.t3.micro"
  engine_version         = "15.00.4420.2.v1"
  port                   = 1433
  allocated_storage      = 20
  storage_type           = "gp3"
  publicly_accessible    = false
  multi_az               = false
  skip_final_snapshot    = true 
  final_snapshot_identifier = "ms-sql-db-terraform-snapshot"
  db_subnet_group_name   = aws_db_subnet_group.rds-SubnetGroup-MS-SQL-Terraform.name
  vpc_security_group_ids = [aws_security_group.sg-MS-SQL-Terraform.id]
  availability_zone      = var.availability_zone-1

  username = "admin"
  password = "Maximum001"

  tags = {
    Name = "ms-sql-db-terraform"
    name = var.tag-name
  }

}

#Step 2: Create security group (Firewall) specific related to MS SQL
resource "aws_security_group" "sg-MS-SQL-Terraform" {
  vpc_id      = aws_vpc.VPC-Terraform.id
  description = "Allow request to MS SQL Server Database created through Terraform"
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "HTTPS egress created through Terraform"
    }
  ]

  ingress = [
    {
      from_port        = 1433
      to_port          = 1433
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "HTTPS ingress created through Terraform"
    }
  ]
  tags = {
    Name = "sg-MS-SQL-Terraform"
    name = var.tag-name
  }
}

#Step 3: Create RDS subnet group, to have multiple subnets into one group, to have options of mutliple AZ & multiple subnets
resource "aws_db_subnet_group" "rds-SubnetGroup-MS-SQL-Terraform" {
  name        = "rds-subnet-group-ms-sql-terraform"
  description = "Subnet Group created through Terraform"
  subnet_ids  = [aws_subnet.Private-Subnet-AZ-1.id, aws_subnet.Private-Subnet-AZ-2.id]
  tags = {
    Name = "rds-SubnetGroup-MS-SQL-Terraform"
    name = var.tag-name
  }
}
