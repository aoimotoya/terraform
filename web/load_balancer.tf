resource "google_compute_global_address" "default" {
  name = "web-lb-ip"
}

resource "google_compute_backend_bucket" "top" {
  name        = "top-backend-bucket"
  bucket_name = google_storage_bucket.top.name
}

resource "google_compute_backend_bucket" "blog" {
  name        = "blog-backend-bucket"
  bucket_name = google_storage_bucket.blog.name
}

resource "google_compute_url_map" "default" {
  name            = "web-url-map"
  default_service = google_compute_backend_bucket.top.id

  host_rule {
    hosts        = [var.domain_names.blog]
    path_matcher = "blog"
  }

  path_matcher {
    name            = "blog"
    default_service = google_compute_backend_bucket.blog.id
  }
}

resource "google_compute_url_map" "redirect" {
  name = "web-url-map-redirect-http-to-https"
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.redirect.id
}

resource "google_compute_target_https_proxy" "default" {
  name    = "https-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.top.name,
    google_compute_managed_ssl_certificate.blog.name
  ]
  depends_on = [
    google_compute_managed_ssl_certificate.top,
    google_compute_managed_ssl_certificate.blog
  ]
}

resource "google_compute_global_forwarding_rule" "redirect" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "https-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
