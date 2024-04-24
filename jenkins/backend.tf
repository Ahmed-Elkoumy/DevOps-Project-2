terraform {
  backend "s3" {
    bucket = "terraform-backend-for-eks-app"
    key    = "jenkins/terraform.tfstate"
    region = "ca-central-1"
  }
}