provider "aws" {
  region ="eu-central-1"
}

resource "aws_ecr_repository" "ecr" {
  name                 = "gonotes"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
    
  tags = {
    Env = "dev"
  }

}
