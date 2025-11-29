data "github_app" "renovate" {
  slug = "renovate"
}

resource "github_branch_protection" "protections" {
  for_each = {
    for item in flatten([
      for repo in local.computed_repositories : [
        for branch in repo.protected_branches : {
          repository_id                   = repo.name
          pattern                         = branch
          required_status_checks_contexts = repo.required_status_checks_contexts
        }
      ] if lookup(repo, "archived", false) == false
    ]) : "${item.repository_id}:${item.pattern}" => item
  }

  repository_id                   = each.value.repository_id
  pattern                         = each.value.pattern
  enforce_admins                  = true
  allows_force_pushes             = false
  allows_deletions                = false
  require_conversation_resolution = true

  required_status_checks {
    strict   = true
    contexts = each.value.required_status_checks_contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = each.value.pattern != "main"
    required_approving_review_count = 1
    pull_request_bypassers          = ["/backnight", data.github_app.renovate.node_id] # TODO: To remove backnight at some point ;)
  }

  restrict_pushes {
    push_allowances = each.value.pattern == "main" ? [github_team.children["release-engineers"].node_id] : []
  }

  depends_on = [null_resource.repositories_branches] # INFO: This is a workaround to avoid Terraform/OpenTofu issue with required_status_checks_contexts blocking the branch creation
}
