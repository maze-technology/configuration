# We *do not* want OpenTofu to manage branches
# as resources, otherwise a future `tofu destroy`
# (or archive) would try to delete them and hit GitHub's
# "422 Cannot delete the default branch" error.
#
# Instead, this one-shot null_resource creates
# branches directly via the GitHub API.  The
# branch is therefore present when `github_branch_default`
# later switches the repo's default, yet it never appears
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

  provisioner "local-exec" {
    interpreter = ["/usr/bin/env", "bash", "-c"]

    command = <<-EOT
      set -euo pipefail
      token='${local.installation_token}'
      repo='${each.value.repo_name}'
      branch='${each.value.branch}'

      echo "Ensuring branch $branch exists in $repo"

      sha=$(curl -s -H "Authorization: Bearer $token" \
                  "https://api.github.com/repos/${var.github_owner}/$repo/git/ref/heads/main" |
            jq -r .object.sha)

      curl -fsSL -X POST \
        -H "Authorization: Bearer $token" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/${var.github_owner}/$repo/git/refs" \
        -d "{\"ref\":\"refs/heads/$branch\",\"sha\":\"$sha\"}" \
        || echo "Branch $branch already exists in $repo"
    EOT
  }

  # Re-runs whenever the repo resource is re-created
  triggers = {
    repo_id = github_repository.repo[each.value.repo_name].id
  }

  depends_on = [github_repository.repo]
}