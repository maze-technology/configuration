resource "github_branch_protection_ruleset" "protections-rulesets" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
  }

  repository_id = github_repository.repo[each.value.name].node_id
  name          = "${each.value.name}-ruleset"
  target        = "branch"
  enforcement   = "enabled"

  rules {
    name = "${each.value.branch_protection_pattern} branch protection rules"
    conditions {
      ref_name = each.value.branch_protection_pattern
    }
    actions {
      required_status_checks {
        strict   = true
        contexts = each.value.required_status_checks_contexts
      }
      required_pull_request_reviews {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }
      restrictions {
        users = []
        teams = []
        apps  = []
      }
      restrict_pushes     = true
      enforce_admins      = true
      allows_deletions    = false
      allows_force_pushes = false
    }
  }
}
