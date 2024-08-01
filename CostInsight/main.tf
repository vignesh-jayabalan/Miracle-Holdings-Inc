terraform {

  required_providers {
    aws = {
      version = ">= 5.39.0"
      source  = "hashicorp/aws"
    }
  }
  cloud {
    organization = "HashiCorp-tanushree"
    workspaces {
      project = "cost_insight"
      name    = "cost_insight_default"
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
