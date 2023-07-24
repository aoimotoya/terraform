output "bucket_name" {
  value = [
    google_storage_bucket.top.name,
    google_storage_bucket.blog.name
  ]
}

output "ip_address" {
  value = google_compute_global_address.default.address
}
