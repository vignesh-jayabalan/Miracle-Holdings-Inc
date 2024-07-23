terraform {
  required_providers {
    tfe = {
      version = "~> 0.55.0"
    }
    tfmigrate = {
      version = "~> 0.1.0"
    }
  }
}

provider "tfmigrate" {
}

provider "tfe" {
  organization = var.org_name
}

locals {
  list_of_new_projects = toset(
    [for key, value in var.migration_directories : value.project_name]
  )
  list_of_working_directories = tolist(
    [for key, value in var.migration_directories : value.working_directory]
  )
  list_of_git_messages = tolist(
    [for key, value in var.migration_directories : value.git_commit_message]
  )
}

resource "tfe_project" "list_of_new_projects" {
  for_each    = local.list_of_new_projects
  name        = each.key
  description = "Created by Terrafrom Migrate from the Github Repository: ${var.github_identifier}"
}

module "workspace_and_variables" {
  depends_on = [tfe_project.list_of_new_projects]
  source     = "./workspace_variables_module"

  for_each = var.migration_directories

  organization_id = var.org_name
  identifier      = var.github_identifier

  working_directory    = each.value.working_directory
  workspace_map        = each.value.workspace_map
  project_name         = each.value.project_name
  branch               = var.git_source_branch
  git_migration_branch = var.git_migration_branch
  remote_name          = var.git_remote
  git_commit_message   = each.value.git_commit_message
  backend_file_name    = each.value.backend_file_name
  tags                 = each.value.tags

}

resource "tfmigrate_git_commit_push" "create_commit" {
  depends_on     = [module.workspace_and_variables]
  count          = length(var.git_migration_branch) > 1 ? 1 : 0
  directory_path = local.list_of_working_directories[0]
  commit_message = local.list_of_git_messages[0]
  enable_push    = true
  branch_name    = var.git_migration_branch
  remote_name    = var.git_remote
}

resource "tfmigrate_github_pr" "migration_pr" {
  depends_on      = [tfmigrate_git_commit_push.create_commit]
  count           = length(var.git_source_branch) > 1 && length(var.github_identifier) > 1 ? 1 : 0
  repo_identifier = var.github_identifier
  pr_title        = "HCP Migration of Workspaces in ${var.github_identifier} repository"
  pr_body         = "This PR is created by TFMigrate CLI to migrate the Workspaces from the repository ${var.github_identifier} to the HCP Workspace."
  source_branch   = var.git_migration_branch
  destin_branch   = var.git_source_branch
}


