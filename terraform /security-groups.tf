module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"

  name        = "prod-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id


  ingress_cidr_blocks =["0.0.0.0/0"] 
  ingress_rules    = ["https-443-tcp",
                      "http-80-tcp",
                      "ssh-tcp"
                     
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      description = "app-port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}