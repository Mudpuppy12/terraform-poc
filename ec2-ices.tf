# Create an EC2 Instance connect endpoint. It will be placed in the first AZ private subnet
# And routing will be able to take it toany other subnet.
# Connect either via consoleor aws cli

# ssh -i ~dennis/Downloads/Key1.pem ubuntu@i-034c20757298bc465d -o ProxyCommand='aws ec2-instance-connect open-tunnel \
# --instance-id i-034c20757298bc465'


resource "aws_ec2_instance_connect_endpoint" "ec2ices" {
  subnet_id = element(module.vpc.public_subnets, 0)
  tags = {
    Name = "EC2ICS for VPC"
  }
}