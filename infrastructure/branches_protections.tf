resource "github_branch_protection" "protections" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
  }

  repository_id          = github_repository.repo[each.value.name].node_id
  pattern                = each.value.branch_protection_pattern
  enforce_admins         = true
  allows_deletions       = false
  allows_force_pushes    = false

  required_status_checks {
    strict   = true
    contexts = each.value.required_status_checks_contexts
  }
}
