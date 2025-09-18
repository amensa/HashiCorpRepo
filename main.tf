provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token
}

resource "tfe_organization" "test-organization" {
  name  = "StefanStoyanovOrg"
  email = "stefanvstoyanov@gmail.com"
}

resource "tfe_project" "HashiCorpInterviewProject" {
  organization = tfe_organization.test-organization.name
  name = "Project1"
}

resource "tfe_oauth_client" "test" {
  organization     = tfe_organization.test-organization.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.oauth_token
  service_provider = "github"
}

resource "tfe_workspace" "parent" {
  name                 = "parent-ws"
  organization         = tfe_organization.test-organization.name
  queue_all_runs       = false
  project_id = tfe_project.HashiCorpInterviewProject.id
  vcs_repo {
    branch             = "main"
    identifier         = "amensa/HashiCorpRepo"
    oauth_token_id     = tfe_oauth_client.test.oauth_token_id 
  }
}

resource "tfe_workspace" "CLI1" {
  name         = "my_CLI-workspace1"
  organization = tfe_organization.test-organization.name
  project_id = tfe_project.HashiCorpInterviewProject.id
}

resource "tfe_workspace" "CLI2" {
  name         = "my_CLI-workspace2"
  organization = tfe_organization.test-organization.name
  project_id = tfe_project.HashiCorpInterviewProject.id
}

resource "tfe_workspace" "CLI3" {
  name         = "my_CLI-workspace3"
  organization = tfe_organization.test-organization.name
  project_id = tfe_project.HashiCorpInterviewProject.id
}

resource "tfe_variable_set" "varset1" {
  name         = "Test Varset"
  description  = "Some description."
  global       = false
  organization = tfe_organization.test-organization.name
}

resource "tfe_variable" "test-a" {
  key             = "seperate_variable"
  value           = "my_value_name"
  category        = "terraform"
  description     = "a useful description"
  variable_set_id = tfe_variable_set.varset1.id
}

resource "tfe_variable" "test-b" {
  key             = "another_variable"
  value           = "my_value_name"
  category        = "env"
  description     = "an environment variable"
  variable_set_id = tfe_variable_set.varset1.id
}

resource "tfe_workspace_variable_set" "VSC-workspace" {
variable_set_id = tfe_variable_set.varset1.id
workspace_id    = tfe_workspace.parent.id
}

resource "tfe_workspace_variable_set" "CLI1-workspace" {
variable_set_id = tfe_variable_set.varset1.id
workspace_id    = tfe_workspace.CLI1.id
}

resource "tfe_workspace_variable_set" "CLI2-workspace" {
variable_set_id = tfe_variable_set.varset1.id
workspace_id    = tfe_workspace.CLI2.id
}

resource "tfe_workspace_variable_set" "CLI3-workspace" {
variable_set_id = tfe_variable_set.varset1.id
workspace_id    = tfe_workspace.CLI3.id
}

variable "tfe_hostname" {
  description = "The hostname of the Terraform Cloud instance"
  type        = string
  default     = "app.terraform.io"
}

variable "tfe_token"{
  description = "The token for the terraform"
  type        = string
  default = "QCfJm0Zmr49BYQ.atlasv1.KXWMrHzLex9mLLvWLws2MzLB9Lmu6lNRtRUKxhO6DzKuSFZGUTkpv83GezWnmys9Ooo"
}

variable "oauth_token" {
  description = "The OAuth token for GitHub integration"
  type        = string
  default     = "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"
}