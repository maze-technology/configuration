locals {
  repository_files = fileset("${path.module}/repositories/files", "**")

  other_files = [
    {
      source_file_path = "../.editorconfig"
      destination_path = ".editorconfig"
    },
    {
      source_file_path = "../.prettierrc.json"
      destination_path = ".prettierrc.json"
    },
    {
      source_file_path = "../.prettierignore"
      destination_path = ".prettierignore"
    },
  ]

  all_repositories_files = concat(
    flatten([
      for repo in local.computed_repositories : [
        for file in local.repository_files : {
          key                 = "${repo.name}/${file}"
          repo_name           = repo.name
          source_file_path    = "${path.module}/repositories/files/${file}"
          destination_path    = file
          files_target_branch = repo.files_target_branch
        }
      ]
    ]),
    flatten([
      for repo in local.computed_repositories : [
        for other_file in local.other_files : {
          key                 = "${repo.name}/${other_file.destination_path}"
          repo_name           = repo.name
          source_file_path    = other_file.source_file_path
          destination_path    = other_file.destination_path
          files_target_branch = repo.files_target_branch
        }
      ]
    ])
  )
}

resource "github_repository_file" "files" {
  for_each = {
    for item in local.all_repositories_files :
    item.key => item
  }

  repository = github_repository.repo[each.value.repo_name].name
  file       = each.value.destination_path
  content    = file(each.value.source_file_path)
  branch = "feature/add-${replace(
    replace(each.value.destination_path, "/", "-"),
    ".", ""
  )}"
  autocreate_branch   = true
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
  body            = "This PR adds the file ${each.value.destination_path}"
}
