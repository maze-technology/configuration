data "http" "installation_token" {
  url    = "https://api.github.com/app/installations/${var.github_app_installation_id}/access_tokens"
  method = "POST"

  request_headers = {
    Authorization = "Bearer ${data.external.github_jwt.result.stdout}"
    Accept        = "application/vnd.github+json"
  }
}

locals {
  installation_token = jsondecode(data.http.installation_token.response_body).token
}