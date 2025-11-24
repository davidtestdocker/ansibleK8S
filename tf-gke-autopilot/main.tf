resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name     # 你的叢集名稱
  location = var.region           # Autopilot 使用「region」不是 zone
  enable_autopilot = true         # 🌟 啟用 Autopilot 模式的新版寫法
                                  # 不再使用 autopilot { enabled = true }

  deletion_protection = false     # 方便你刪除，不然需要再手動關閉 DP
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.repository_name
  description   = "Artifact Registry for multi-k8s images"
  format        = "DOCKER"
}

resource "google_service_account" "gke_sa" {
  account_id   = "gke-deployer"
  display_name = "GKE Deployer Service Account"
}

resource "google_project_iam_member" "gke_sa_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}
