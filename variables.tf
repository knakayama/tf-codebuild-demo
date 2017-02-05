variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "tf-codebuild-demo"
}

variable "codebuild_config" {
  default = {
    source_location = "https://github.com/knakayama/serverless-sample-app.git"
    stage           = "dev"
  }
}
