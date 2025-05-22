provider "github" {
  owner = var.github_owner

  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file(var.github_app_private_key_path)
  }
}

provider "docker" {
  username = var.docker_username
  password = var.docker_password
}