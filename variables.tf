variable "region" {
  default = "asia-northeast1"
}

variable "project" {
  default = "aoimotoya-websites"
}

variable "domain_names" {
  type = map(any)
  default = {
    top  = "aoimotoya.net"
    blog = "blog.aoimotoya.net"
  }
}
