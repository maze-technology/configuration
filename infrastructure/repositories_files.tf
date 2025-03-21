resource "github_repository_file" "files" {
  for_each = {
    for item in local.all_repositories_files :
    item.key => item
  }

  repository          = github_repository.repo[each.value.repo_name].name
  file                = each.value.destination_path
  content             = file(each.value.source_file_path)
  branch              = "main"
  commit_message      = "Add ${each.value.destination_path}"
  overwrite_on_create = true

  depends_on = [
    github_branch_protection.protections["${each.value.repo_name}:main"]
  ]
}
