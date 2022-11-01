module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "prod-vpc"
  cidr = "172.30.0.0/16"

 
  azs                 = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets     = ["172.30.1.0/24", "172.30.2.0/24", "172.30.3.0/24"]
  public_subnets      = ["172.30.4.0/24", "172.30.5.0/24", "172.30.6.0/24"]
  private_subnet_names = ["pv-sub1", "pv-sub2", "pv-sub3"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

}