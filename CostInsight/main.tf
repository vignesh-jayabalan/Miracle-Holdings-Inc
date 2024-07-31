terraform {

  backend "s3" {
    bucket               = "tanushree-test1"
    workspace_key_prefix = "terraform-states/cost-insight"
    key                  = "terraform.tfstate"
    region               = "us-west-2"
  }
  required_providers {
    aws = {
      version = ">= 5.39.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}


module "shared_module_consumer" {
  source           = "../Shared-Module"
  workspace_name   = terraform.workspace
  application_name = "cost-insight"
}
