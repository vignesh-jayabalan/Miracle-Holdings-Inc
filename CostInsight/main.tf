terraform {

  required_providers {
    aws = {
      version = ">= 5.39.0"
      source  = "hashicorp/aws"
    }
  }
  cloud {
    organization = "Miracle-Holdings-Inc"
    hostname     = "miracle-holdings.com"
    workspaces {
      project = "cost_insight"
      tags    = ["cost_insight"]
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
