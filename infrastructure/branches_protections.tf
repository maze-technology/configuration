resource "github_branch_protection_v3" "protections" {
  for_each = {
    for item in flatten([
      for repo in local.computed_repositories : [
        for branch in repo.protected_branches : {
          name                            = repo.name
          branch                          = branch
          required_status_checks_contexts = repo.required_status_checks_contexts
        }
      ]
    ]) : "${item.name}:${item.branch}" => item
  }

  repository     = each.value.name
  branch         = each.value.branch
  enforce_admins = true

  required_status_checks {
    strict = true
    checks = each.value.required_status_checks_contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }

  restrictions {
    users = []
    teams = []
    apps  = ["maze-workflows"]
  }
}
