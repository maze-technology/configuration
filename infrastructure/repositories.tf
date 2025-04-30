locals {
  computed_repositories = concat(var.repositories, [
    {
      name                            = "github-configuration"
      description                     = "GitHub organization configuration repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = false
      push_teams                      = ["github-engineers", "opentofu-engineers", "release-engineers"]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name                            = ".github"
      description                     = "GitHub repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = false
      push_teams                      = ["github-engineers", "release-engineers"]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name                            = "${var.github_owner}.github.io"
      description                     = "Website repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = true
      push_teams                      = ["release-engineers"]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name                            = "commons"
      description                     = "Commons library repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = false
      push_teams                      = ["java-engineers", "github-engineers", "protobuf-engineers", "release-engineers"]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build"]
    },
    {
      name                            = "java-service-template"
      description                     = "Java service base template repository"
      visibility                      = "public"
      is_template                     = true
      dynamic_pages                   = false
      push_teams                      = ["java-engineers", "github-engineers", "protobuf-engineers", "release-engineers"]
      branches                        = ["develop"]
      protected_branches              = ["main", "develop"]
      default_branch                  = "develop"
      required_status_checks_contexts = ["build"]
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
  allow_merge_commit     = false
  allow_squash_merge     = false
  allow_rebase_merge     = true
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
  branch     = github_branch.repositories_branches["${each.value.name}-${each.value.default_branch}"].branch
}
