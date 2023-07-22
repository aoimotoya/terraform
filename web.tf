terraform {
  cloud {
    organization = "aoimotoya"

    workspaces {
      name = "web"
    }
  }
}
