variable "org_name" {
  default = "MiracleHoldings-INC-Terraform"
}
variable "git_migration_branch" {
  default = "hcp-migrate-main"
}
variable "git_remote" {
  default = "origin"
}
variable "git_source_branch" {
  default = "main"
}
variable "github_identifier" {
  default = "vignesh-jayabalan/Miracle-Holdings-Inc"
}
variable "skipped_tf_dirs" {
  default = []
}
variable "migration_directories" {
  default = {
    CreditBoost = {
      backend_file_name  = "main.tf"
      current_backend    = "s3"
      git_commit_message = "[skip ci] Migrating local Workspaces from CreditBoost to TFC"
      project_name       = "credit_boost"
      tags               = ["credit_boost"]
      working_directory  = "/Users/vigneshjayabalan/hashicorp/src/github/vignesh.jayabalan/Miracle-Holdings-Inc/CreditBoost"
      workspace_map = {
        default = "credit_boost_default"
      }
    }
  }
}
