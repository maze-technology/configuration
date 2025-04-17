resource "github_branch" "repositories_branches" {
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

  repository    = github_repository.repo[each.value.repo_name].name
  branch        = each.value.branch
  source_branch = "main"

  depends_on = [github_repository.repo[each.value.name]]
}
