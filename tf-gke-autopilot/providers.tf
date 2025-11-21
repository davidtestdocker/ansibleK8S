terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"   # 使用官方 Google Provider
      version = ">= 5.0.0"           # Autopilot 新語法必須用 v5+
    }
  }
}

provider "google" {
  project = var.project_id           # GCP 專案 ID
  region  = var.region               # 預設地區
}

