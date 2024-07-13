resource "aws_acm_certificate" "cert" {
  domain_name       = var.backend_domain
  validation_method = "DNS"

  tags = {
    Name = "example-cert"
  }
}