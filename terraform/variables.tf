variable "project" {}

variable "region" {}

variable "zone" {}

variable "machine_type" {
  default = "f1-micro"
}

variable "startup_scripts" {
  type = "map"
}

variable "static_ips" {
  type = "map"
}

variable "machine_image" {
  default = "ubuntu-1604-xenial-v20180109"
}

variable "subnet_cidrs" {
  type = "map"
}