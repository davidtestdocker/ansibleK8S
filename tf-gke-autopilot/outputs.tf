output "cluster_name" {
  value = google_container_cluster.autopilot.name
}

output "endpoint" {
  value = google_container_cluster.autopilot.endpoint
}

output "location" {
  value = google_container_cluster.autopilot.location
}


output "artifact_repo" {
  value = google_artifact_registry_repository.repo.repository_id
}
