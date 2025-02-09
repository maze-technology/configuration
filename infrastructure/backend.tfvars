bucket         = "maze-github_github-opentofu-state"
encrypt        = true
key            = "github/terraform.tfstate"
region         = "eu-central-1"
kms_key_id     = "alias/maze-github_github-opentofu-state-key"
dynamodb_table = "maze-github_github-opentofu-locks"
