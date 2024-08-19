
# Create Instance

resource "aws_instance" "zertotier_gw" {
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  subnet_id              = element(module.vpc.public_subnets, 0)
  key_name               = "Key1"
  vpc_security_group_ids = [aws_security_group.zt_server_sg_tf.id]

  source_dest_check = false

  tags = {
    Name = "Zero Tier GW"
  }
}

