locals {
  computed_repositories = concat(var.repositories, [
    {
      name          = "github-configuration"
      description   = "GitHub organization configuration repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.teams["github-engineers"].name,
        github_team.teams["infrastructure-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name          = ".github"
      description   = "GitHub repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.teams["github-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name          = "${var.github_owner}.github.io"
      description   = "Website repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = true
      push_teams = [
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name          = "smithy-protovalidate"
      description   = "Smithy Protovalidate repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.teams["python-engineers"].name,
        github_team.teams["idl-engineers"].name,
        github_team.teams["github-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = []
    },
    {
      name          = "commons"
      description   = "Commons library repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.teams["java-engineers"].name,
        github_team.teams["github-engineers"].name,
        github_team.teams["idl-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build"] # TODO: Rename to build_scan
    },
    {
      name          = "smithy-events-codegen"
      description   = "Smithy events codegen repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
      push_teams = [
        github_team.teams["github-engineers"].name,
        github_team.teams["java-engineers"].name,
        github_team.teams["idl-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = []
    },
    {
      name          = "hello-world-idl-template"
      description   = "Hello World IDL base template repository"
      visibility    = "public"
      is_template   = true
      dynamic_pages = false
      push_teams = [
        github_team.teams["github-engineers"].name,
        github_team.teams["idl-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build_scan"]
    },
    {
      name          = "java-hello-world-service-template"
      description   = "Java Hello World Service base template repository"
      visibility    = "public"
      is_template   = true
      dynamic_pages = false
      push_teams = [
        github_team.teams["java-engineers"].name,
        github_team.teams["github-engineers"].name,
        github_team.teams["release-engineers"].name
      ]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build"] # TODO: Rename to build_scan
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
}
