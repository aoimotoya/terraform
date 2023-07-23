provider "google-beta" {
  project = var.project
}

resource "google_compute_managed_ssl_certificate" "top" {
  name = "top-ssl-cert"
  managed {
    domains = [var.domain_names.top]
  }
}

resource "google_compute_global_address" "top" {
  name = "top-lb-ip"
}

resource "google_compute_backend_bucket" "top" {
  name        = "top-backend-bucket"
  bucket_name = google_storage_bucket.top.name
}

resource "google_compute_url_map" "top" {
  name            = "top-url-map"
  default_service = google_compute_backend_bucket.top.id
}

resource "google_compute_url_map" "redirect" {
  name = "top-url-map-redirect-http-to-https"
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_target_http_proxy" "top" {
  name    = "top-http-proxy"
  url_map = google_compute_url_map.redirect.id
}

resource "google_compute_target_https_proxy" "top" {
  name    = "top-https-proxy"
  url_map = google_compute_url_map.top.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.top.name
  ]
  depends_on = [
    google_compute_managed_ssl_certificate.top
  ]
}

resource "google_compute_global_forwarding_rule" "top_http" {
  name                  = "top-http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.top.id
  ip_address            = google_compute_global_address.top.id
}

resource "google_compute_global_forwarding_rule" "top_https" {
  name                  = "top-https-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.top.id
  ip_address            = google_compute_global_address.top.id
}
