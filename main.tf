terraform {
  backend "s3" {
    bucket       = "ikerian-terraform"
    key          = "global"
    region       = "us-east-1"
    use_lockfile = true
  }
}
