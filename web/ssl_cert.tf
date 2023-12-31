resource "google_compute_managed_ssl_certificate" "top" {
  name = "top-ssl-cert"
  managed {
    domains = [local.domain_names.top]
  }
}

resource "google_compute_managed_ssl_certificate" "blog" {
  name = "blog-ssl-cert"
  managed {
    domains = [local.domain_names.blog]
  }
}
