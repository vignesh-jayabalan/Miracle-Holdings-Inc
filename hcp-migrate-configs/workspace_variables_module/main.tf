
data "tfe_project" "project" {
  name         = var.project_name
  organization = var.organization_id
}

resource "tfe_workspace" "workspaces" {
  for_each            = var.workspace_map
  name                = each.value
  queue_all_runs      = false
  project_id          = data.tfe_project.project.id
  assessments_enabled = false
}

resource "tfmigrate_terraform_init" "terraform_init" {
  depends_on     = [tfe_workspace.workspaces]
  directory_path = var.working_directory
}

resource "tfmigrate_state_migration" "state-migration" {
  depends_on      = [tfmigrate_terraform_init.terraform_init]
  for_each        = var.workspace_map
  local_workspace = each.key
  tfc_workspace   = each.value
  directory_path  = var.working_directory
  org             = var.organization_id
}

resource "tfmigrate_update_backend" "update-backend" {
  depends_on        = [tfmigrate_state_migration.state-migration]
  org               = var.organization_id
  project           = data.tfe_project.project.name
  directory_path    = var.working_directory
  backend_file_name = var.backend_file_name
  workspace_map     = var.workspace_map
  tags              = var.tags
}

resource "tfmigrate_git_commit_push" "create_commit" {
  depends_on     = [tfmigrate_update_backend.update-backend]
  count          = length(var.git_migration_branch) > 1 ? 1 : 0
  directory_path = var.working_directory
  commit_message = var.git_commit_message
  enable_push    = true
  branch_name    = var.git_migration_branch
  remote_name    = var.remote_name
}
