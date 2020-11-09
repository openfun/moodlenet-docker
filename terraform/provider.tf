provider "aws" {
  alias = "default"
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1" 
}
