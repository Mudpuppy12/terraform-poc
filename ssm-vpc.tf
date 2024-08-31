
data "aws_route_tables" "rts" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*-private"]
  }
}

data "aws_subnets" "private_routable" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }

  tags = {
    "Routable" = "true"
    "Type"     = "private"
  }
}

# VPC Endpoint to S3 
resource "aws_vpc_endpoint" "s3-endpt" {
  vpc_id          = module.vpc.vpc_id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = data.aws_route_tables.rts.ids

  tags = {
    Name = "S3 Endpoint Access"
  }
}

# SSM endpoints into private VLANS

resource "aws_vpc_endpoint" "ssm-endpt" {
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.http_allow.id
  ]

  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"

  tags = {
    Name = "SSM Endpoint Private Access"
  }
}

resource "aws_vpc_endpoint" "ssmmsgs-endpt" {
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.http_allow.id
  ]

  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"

  tags = {
    Name = "SSM Messages Endpoint Private Access"
  }
}

resource "aws_vpc_endpoint" "kms-endpt" {
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.http_allow.id
  ]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.kms"

  tags = {
    Name = "KMS Endpoint Private Access"
  }
}

resource "aws_vpc_endpoint" "cloudwatch-logs-endpt" {
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.http_allow.id
  ]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"

  tags = {
    Name = "Cloudwatch Endpoint Private Access"
  }
}

resource "aws_vpc_endpoint" "ec2msgs-endpt" {
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.http_allow.id
  ]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  tags = {
    Name = "EC2 Messages Endpoint Private Access"
  }
}

