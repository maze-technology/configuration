terraform {
  backend "s3" {
    encrypt = true
    key     = "github/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.5"
    }

    docker = {
      source  = "docker/docker"
      version = "~> 0.5"
    }
  }
}
