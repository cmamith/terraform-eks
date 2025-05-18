terraform {
   backend "s3"{
    bucket = "my-tf-eks-state"
    key            = "dev/eks/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-eks-locks"
    encrypt        = true
   }
}