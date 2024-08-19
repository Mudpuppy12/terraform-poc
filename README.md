* Run Terraform
* Update Ansible Inventory
* Run zerotier.yml
* Accept ZT Gateway client in My ZeroTier
* Update Route for VPC 10.0.0.0/16 to ZT Gateway Client IP
* Run ngix.yml



# Notes
* EC2 ICE Service only works if host SSH is opened in the sq to public IP address of client.

*  ie ssh -i ~dennis/Downloads/Key1.pem ubuntu@i-07e688100a95f8070 -o ProxyCommand='aws ec2-instance-connect open-tunnel --instance-id i-07e688100a95f8070'
   is opened to your public IP


