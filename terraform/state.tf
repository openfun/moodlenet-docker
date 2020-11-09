terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key             = "moodlenet.tfstate"
    encrypt         = true
    bucket          = "moodlenet-terraform"
    dynamodb_table  = "moodlenet_state_locks"
  }
}
