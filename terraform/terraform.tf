terraform {
  backend "s3" {
    bucket       = "terraform-s3-backend-tws-hackathon-ying"
    key          = "backend-locking"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
#Locking can be enabled via S3 or DynamoDB. However, DynamoDB-based locking is deprecated and will be removed in a future minor version.
#use_lockfile - (Optional) Whether to use a lockfile for locking the state file. Defaults to false.