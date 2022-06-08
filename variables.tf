# Account vars
variable "project_id" {
    type = string
    default = "rayane-devops-test21"
}
variable "region" {
    type = string
    default = "europe-west1"
}
variable "service-account-id" {
    type = string
    default = "480598896473-compute@developer.gserviceaccount.com"
}


# GKE cluster vars
variable "gke_username" {
  default     = "sping"
  description = "gke username"
}


variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "machine_type" {
  default     = "e2-medium"
  description = "type of machine use for nodes"
}
