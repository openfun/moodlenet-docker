variable "cloudfront_price_class" {
  type = map(string)

  default = {
    production = "PriceClass_All"
  }
}

variable "cloudfront_moodlenet_domain_name" {
  type = string
}
