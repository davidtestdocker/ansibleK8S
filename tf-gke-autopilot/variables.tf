variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GKE 區域，例如 asia-east1"
  type        = string
  default     = "asia-east1"  # 你可以改成你想要的最便宜區域
}

variable "cluster_name" {
  description = "GKE Autopilot cluster name"
  type        = string
  default     = "autopilot-cluster"
}

variable "repository_name" {
  type        = string
  default     = "multik8s2-repo"
}
