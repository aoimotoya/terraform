output "bucket_name" {
  value = [
    google_storage_bucket.top.name,
    google_storage_bucket.blog.name
  ]
}
