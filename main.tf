terraform {
  required_version = "~> 0.8.6"
}

provider "aws" {
  region = "${var.region}"
}
