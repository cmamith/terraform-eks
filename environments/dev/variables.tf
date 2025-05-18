variable "aws_region" {}
variable "cluster_name" {}
variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}