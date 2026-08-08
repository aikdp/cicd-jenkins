terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }

  backend "s3" {
    bucket       = "s3-state-file-management-tf"
    key          = "cicd-jenkins-learn.tfstate"
    use_lockfile = true
    region       = "us-east-1"
    encrypt = true
  }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

# s3-state-file-management-tf