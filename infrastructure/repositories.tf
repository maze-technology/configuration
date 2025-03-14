resource "github_repository" "repo" {
  for_each                = { for repo in local.computed_repositories : repo.name => repo }
  name                    = each.value.name
  description             = each.value.description
  visibility              = each.value.visibility
  has_issues              = true
  has_wiki                = false
  has_projects            = false
  has_downloads           = false
  archive_on_destroy      = true
  is_template             = each.value.is_template
  allow_merge_commit      = false
  allow_squash_merge      = true
  allow_rebase_merge      = false
  allow_auto_merge        = false
  delete_branch_on_merge  = true
  auto_init               = true # INFO: Mandatory for adding a license file later
  vulnerability_alerts    = true

  dynamic "pages" {
    for_each = each.value.dynamic_pages ? [1] : []

    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }
}

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
}
