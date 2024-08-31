resource "aws_instance" "hosts" {
  count                  = length(module.vpc.private_subnets)
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  subnet_id              = element(module.vpc.private_subnets, count.index)
  key_name               = "Key1"
  vpc_security_group_ids = [aws_security_group.ec2_server_sg_tf.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  monitoring             = true

  source_dest_check = false

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  tags = {
    Name = "Test Host ${count.index + 1}"
  }
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-ec2-profile"
  role = aws_iam_role.ssm_role.name
}