terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.20.0"
    }
  }
  
  backend "gcs" {
    bucket = "rayane-gke-bucket"
  }
}