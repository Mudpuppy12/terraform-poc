resource "aws_instance" "hosts" {
  count                  = length(module.vpc.private_subnets)
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  subnet_id              = element(module.vpc.private_subnets, count.index)
  key_name               = "Key1"
  vpc_security_group_ids = [aws_security_group.ec2_server_sg_tf.id]

  source_dest_check = false

  tags = {
    Name = "Test Host ${count.index + 1}"
  }
}

