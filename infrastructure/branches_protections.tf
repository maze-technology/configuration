resource "github_branch_protection" "protections" {
  for_each = {
    for item in flatten([
      for repo in local.computed_repositories : [
        for branch in repo.protected_branches : {
          repository_id                   = repo.name
          pattern                         = branch
          required_status_checks_contexts = repo.required_status_checks_contexts
        }
      ]
    ]) : "${item.repository_id}:${item.pattern}" => item
  }

  repository_id       = each.value.repository_id
  pattern             = each.value.pattern
  enforce_admins      = true
  allows_force_pushes = false
  allows_deletions    = false
  require_conversation_resolution = true
  required_linear_history = each.value.pattern == "main"

  required_status_checks {
    strict   = true
    contexts = each.value.required_status_checks_contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = each.value.pattern != "main"
    required_approving_review_count = 1
    pull_request_bypassers          = ["/backnight"] # TODO: To remove at some point ;)
  }

  restrict_pushes {
    push_allowances = each.value.pattern == "main" ? ["@maze-technology/release-engineers"] : []
  }
}
