data "external" "github_jwt" {
  program = [
    "bash",
    "${path.module}/scripts/make-jwt.sh",
    var.github_app_id,
    var.github_app_installation_id,
    var.github_app_private_key_path
  ]
}