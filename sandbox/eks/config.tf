terraform {

  backend "s3" {

    bucket = "ppg9912-tf-state-bucket-02"
    key = "./sandbox/eks/terraform.tfstate"
    region = "us-west-1"

    dynamodb_table = "pg-tf-state-locks_02"
    encrypt = true
  }

}

provider "aws" {
  profile = "aws-lab-tf"
  region  = "us-west-1"
}