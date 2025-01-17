resource "aws_dynamodb_table" "terraform-state-locks" {
  name           = "moodlenet_state_locks"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
