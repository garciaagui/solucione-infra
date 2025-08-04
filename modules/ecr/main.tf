resource "aws_ecr_repository" "solucione_ecr" {
  name                 = "solucione-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
