module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name = "prod-server"

  ami                         = local.ami
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = "prod-server"
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.sg.security_group_id]
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.user_data)

  hibernation = true

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = true
    }
  ]

 
}



