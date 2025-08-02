terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.6.0"
    }
  }

  backend "s3" {
    bucket = "solucione-state-bucket"
    key    = "state/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  # Profile será lido automaticamente da variável de ambiente AWS_PROFILE
  # Caso não tenha configurado, execute em seu terminal: export AWS_PROFILE=seu_profile

  default_tags {
    tags = {
      IAC = "True"
    }
  }
}
