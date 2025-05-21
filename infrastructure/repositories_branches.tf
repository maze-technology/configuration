# We *do not* want OpenTofu to manage the develop branch
# as a resource, otherwise a future `tofu destroy`
# (or archive) would try to delete it and hit GitHub's
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

  # Use the GitHub App authentication to create branches from main's HEAD
  provisioner "local-exec" {
    command     = <<-EOT
      set -euo pipefail
      # Generate a token using the GitHub App credentials
      token=$(curl -s -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer $(echo '${base64encode(file(var.github_app_private_key_path))}' | base64 -d | openssl dgst -sha256 -sign <(echo '${base64encode(file(var.github_app_private_key_path))}' | base64 -d) | base64 -w 0)" \
        "https://api.github.com/app/installations/${var.github_app_installation_id}/access_tokens" | jq -r .token)

      # Use the generated token to create the branch
      sha=$(curl -s -H "Authorization: Bearer $token" \
        "https://api.github.com/repos/${var.github_owner}/${each.value.repo_name}/git/ref/heads/main" | jq -r .object.sha)

      curl -s -X POST \
        -H "Authorization: Bearer $token" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/${var.github_owner}/${each.value.repo_name}/git/refs" \
        -d "{\"ref\":\"refs/heads/${each.value.branch}\",\"sha\":\"$sha\"}"
    EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  # Re-run only if the repo gets recreated
  triggers = {
    repo_id = github_repository.repo[each.value.repo_name].id
  }

  depends_on = [github_repository.repo]
}