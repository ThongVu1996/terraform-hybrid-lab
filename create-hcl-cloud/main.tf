resource "tfe_organization" "org" {
  name  = var.org_name
  email = var.org_email
}

resource "tfe_agent_pool" "pool" {
  name                = var.agent_pool_name
  organization        = tfe_organization.org.name
  organization_scoped = true
}

resource "tfe_project" "project" {
  name         = var.project_name
  organization = tfe_organization.org.name
}

resource "tfe_workspace" "workspace" {
  name           = var.workspace_name
  organization   = tfe_organization.org.name
  project_id     = tfe_project.project.id
  execution_mode = "agent"
  agent_pool_id  = tfe_agent_pool.pool.id
}

resource "tfe_agent_token" "token" {
  agent_pool_id = tfe_agent_pool.pool.id
  description   = "Token cho VM-101-Proxmox"
}

output "hcp_agent_token" {
  value     = tfe_agent_token.token.token
  sensitive = true
}
