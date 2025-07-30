terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.6.0"
    }
  }
}

provider "aws" {
  # Profile será lido automaticamente da variável de ambiente AWS_PROFILE
  # Caso não tenha configurado, execute em seu terminal: export AWS_PROFILE=seu_profile
}
