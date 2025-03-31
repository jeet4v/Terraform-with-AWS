resource "aws_lb" "lb-Terraform" {
  name = "lb-Terraform"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg-Load-Balancer-Terraform.id]
  subnets = [aws_subnet.Public-Subnet-AZ-1.id, aws_subnet.Public-Subnet-AZ-2.id]
  enable_deletion_protection = false
  tags = {
    name = var.tag-name
  }
}

resource "aws_lb_target_group" "lb-Target-Group-Terraform" {
  name = "lb-Target-Group-Terraform"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.VPC-Terraform.id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
  tags = {
    name = var.tag-name
  }
}

resource "aws_lb_listener" "lb-Listener-HTTP" {
  load_balancer_arn = aws_lb.lb-Terraform.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb-Target-Group-Terraform.arn
  }
  tags = {
    Name = "lb-Listener-HTTP"
    name = var.tag-name
  }
}

# Attach EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "tg_attachment1" {
  target_group_arn = aws_lb_target_group.lb-Target-Group-Terraform.arn
  target_id        = aws_instance.Private-VM-AZ-1-Terraform.id
  port             = 80
}

# Attach EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "tg_attachment2" {
  target_group_arn = aws_lb_target_group.lb-Target-Group-Terraform.arn
  target_id        = aws_instance.Private-VM-AZ-2-Terraform.id
  port             = 80
}

resource "aws_security_group" "sg-Load-Balancer-Terraform" {
  vpc_id = aws_vpc.VPC-Terraform.id
  description = "Allow request to Application Load Balancer created through Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-Load-Balancer-Terraform"
    name = var.tag-name
  }
}