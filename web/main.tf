terraform {
  cloud {
    organization = "aoimotoya"

    workspaces {
      name = "web"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

provider "google-beta" {
  project = local.project
}
