provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "../../modules/iam"
  env    = "dev"
}


module "vpc" {
  source        = "../../modules/vpc"
  env = "dev"
  vpc_cidr      = var.vpc_cidr
  public_subnets = var.public_subnets
}

module "eks" {
  source           = "../../modules/eks"
  cluster_name     = var.cluster_name
  subnet_ids       = module.vpc.public_subnet_ids
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
}