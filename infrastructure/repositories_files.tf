resource "github_repository_file" "files" {
  for_each = {
    for item in local.all_repositories_files :
    item.key => item
  }

  repository          = github_repository.repo[each.value.repo_name].name
  file                = each.value.destination_path
  content             = file(each.value.source_file_path)
  branch              = "feature/add-${each.value.destination_path}"
  commit_message      = "Add ${each.value.destination_path}"
  overwrite_on_create = true
}

resource "github_repository_pull_request" "file-prs" {
  for_each = {
    for item in local.all_repositories_files :
    item.key => item
  }

  base_repository = github_repository.repo[each.value.repo_name].name
  base_ref        = each.value.files_target_branch
  head_ref        = github_repository_file.files[each.key].branch
  title           = "Add ${each.value.destination_path}"
  body            = "This PR adds the file ${each.value.destination_path}."

  depends_on = [
    github_repository.repo[each.value.repo_name],
    github_repository_file.files[each.key]
  ]
}
