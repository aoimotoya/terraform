terraform {
  cloud {
    organization = "aoimotoya"

    workspaces {
      name = "web"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "top" {
  name          = "web-top-${random_id.bucket_suffix.hex}"
  location      = "asia-northeast1"
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket" "blog" {
  name          = "web-blog-${random_id.bucket_suffix.hex}"
  location      = "asia-northeast1"
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_member" "top" {
  bucket = google_storage_bucket.top.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "blog" {
  bucket = google_storage_bucket.blog.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
