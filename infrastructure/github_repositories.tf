locals {
  computed_repositories = concat(var.github_repositories, [
    {
      name          = "configuration"
      description   = "Repository managing the GitHub configuration and other public resources"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name,
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["check-fmt-opentofu", "plan-opentofu"]
    },
    {
      name          = "infrastructure-global"
      description   = "Repository managing global infrastructure configuration"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.children["infrastructure-engineers"].name,
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks (check-fmt-opentofu, plan-opentofu)
    },
    {
      name          = ".github"
      description   = "GitHub repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name,
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name          = "${var.github_owner}.github.io"
      description   = "Documentation website"
      visibility    = "public"
      is_template   = false
      dynamic_pages = true
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name          = "smithy-protovalidate"
      description   = "Smithy ProtoValidate"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = []
    },
    {
      name          = "commons"
      description   = "Commons library"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build_scan", "check-fmt-smithy"]
    },
    {
      name          = "spring-eventstream"
      description   = "Spring EventStream library"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build_scan"]
      archived                        = true
    },
    {
      name          = "smithy-temporal-traits"
      description   = "Smithy Temporal traits"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["check-fmt-smithy"]
    },
    {
      name          = "smithy-temporal-codegen"
      description   = "Smithy Temporal codegen plugin"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name          = "hello-world-specs-template"
      description   = "Hello World specs base template"
      visibility    = "public"
      is_template   = true
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build_scan", "check-fmt-smithy"]
    },
    {
      name          = "java-hello-world-backend-template"
      description   = "Java Hello World backend service base template"
      visibility    = "public"
      is_template   = true
      dynamic_pages = false
      push_teams = [
        github_team.parents["engineers"].name
      ]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build_scan"]
      docker_hub_repository = {
        name        = "hello-world-backend"
        description = "Hello World backend service"
      }
    }
  ])
}

resource "github_repository" "repo" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
  }

  name                   = each.value.name
  description            = each.value.description
  visibility             = each.value.visibility
  has_issues             = true
  has_wiki               = false
  has_projects           = false
  has_downloads          = false
  archive_on_destroy     = true
  is_template            = each.value.is_template
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = false
  allow_auto_merge       = false
  allow_update_branch    = true
  delete_branch_on_merge = true
  auto_init              = true # INFO: Mandatory for adding files later
  vulnerability_alerts   = true
  archived               = lookup(each.value, "archived", false)

  dynamic "pages" {
    for_each = each.value.dynamic_pages ? [1] : []

    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }

  dynamic "template" {
    for_each = lookup(each.value, "template", null) == null ? [] : [lookup(each.value, "template", null)]

    content {
      owner                = each.value.template.owner
      repository           = each.value.template.repository
      include_all_branches = true
    }
  }
}

resource "github_branch_default" "default_branch" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
    if lookup(repo, "default_branch", null) != null
  }

  repository = github_repository.repo[each.value.name].name
  branch     = each.value.default_branch

  depends_on = [
    null_resource.repositories_branches
  ]
}
