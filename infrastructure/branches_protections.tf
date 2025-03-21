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

  required_status_checks {
    strict   = true
    contexts = each.value.required_status_checks_contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }

  restrict_pushes {
    push_allowances = [
      "1146491" # Maze Workflows app ID
    ]
  }
}
