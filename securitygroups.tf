# Default VPC security group

# Let SSH through console to EC2 Public Instances

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  count = length(var.admin_subnets)

  security_group_id = module.vpc.default_security_group_id
  cidr_ipv4         = element(var.admin_subnets, count.index)
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = module.vpc.default_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Default EC2 Security group for EC2 Hosts

resource "aws_security_group" "ec2_server_sg_tf" {
  name        = "ec2-server-sg-tf"
  description = "Allow SSH to server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "VPC IP Ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "Admin Security groups SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_subnets
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2 Default Host Security Group"
  }
}

# Security Group for ZeroTier UDP

resource "aws_security_group" "zt_server_sg_tf" {
  name        = "zt-server-sg-tf"
  description = "Allow SSH and UDP to server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Admin Security groups"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_subnets
  }

  ingress {
    description = "UDP ZT VPN Ingress"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "VPC IP Ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ZT Default Host Security Group"
  }
}

# Security Group for ALB
resource "aws_security_group" "sg_for_elb" {
  name   = "sg_for_elb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow https request from anywhere"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ELB Traffic Security Group"
  }

}