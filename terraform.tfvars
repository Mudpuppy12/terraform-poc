# Generic Variables
region      = "east-1"
environment = "poc"
owners      = "aws"


# VPC Variables
name                               = "vpc-terraform" # Overridning the name defined in variable file
cidr                               = "10.0.0.0/16"
azs                                = ["us-east-1c", "us-east-1d", "us-east-1e"]
public_subnets                     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
private_subnets                    = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]
create_database_subnet_group       = false
create_database_subnet_route_table = false
enable_nat_gateway                 = true
single_nat_gateway                 = true
one_nat_gateway_per_az             = false

# SSM Variables
s3_bucket = "ssm"


# ZeroTier

#Admin Networks (Starlink, Spectrum, us-east-1 console access)
admin_subnets = ["98.97.80.29/32", "76.183.229.179/32", "18.206.107.24/29"]


