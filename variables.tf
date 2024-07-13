variable "s3_bucket" {
  type = string
  default = "cf-templates-1ohbdpx0bstp8-us-east-1"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}
variable "registry_credential" {
  type = string
  default = "registry_credential"
}
variable "backend_domain" {
  type = string
  default = "api.auto.io.vn"
}
