# We *do not* want OpenTofu to manage the develop branch
# as a resource, otherwise a future `tofu destroy`
# (or archive) would try to delete it and hit GitHub’s
# “422 Cannot delete the default branch” error.
#
# Instead, this one-shot null_resource creates
# branches directly via the GitHub API.  The
# branch is therefore present when `github_branch_default`
# later switches the repo’s default, yet it never appears
# in OpenTofu state—so it will never be deleted.
resource "null_resource" "repositories_branches" {
  for_each = {
    for branch_obj in flatten([
      for repo in local.computed_repositories : [
        for branch in repo.branches : {
          repo_name = repo.name
          branch    = branch
        }
      ]
    ]) : "${branch_obj.repo_name}-${branch_obj.branch}" => branch_obj
  }

  # Use the GitHub CLI (or curl) to create branches from main’s HEAD.
  # Assumes you have a GH_TOKEN with repo:write in the env OpenTofu runs in.
  provisioner "local-exec" {
    command     = <<-EOT
      set -euo pipefail
      sha=$(gh api repos/${var.github_owner}/${each.key}/git/ref/heads/main --jq .object.sha)
      gh api -X POST repos/${var.github_owner}/${each.key}/git/refs \
             -f ref="refs/heads/${each.value.branch}" -f sha="$sha" --silent
    EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  # Re-run only if the repo gets recreated
  triggers = {
    repo_id = github_repository.repo[each.value.repo_name].id
  }

  depends_on = [github_repository.repo]
}