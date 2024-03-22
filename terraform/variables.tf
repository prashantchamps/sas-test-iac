variable "app_name" {
  type        = string
  description = "name of the app"
  default     = "hobbes"
}
variable "location" {
  type        = string
  description = "Location of Resources"
  default     = "eastus"
}
variable "rg-name" {
  type        = string
  description = "A prefix used for all resources in this example"
  default     = "sas-test"
}
variable "cluster-name" {
  type        = string
  description = "A prefix used for all resources in this example"
  default     = "sas-test-aks"
}
variable "acr-name" {
  type        = string
  description = "A prefix used for all resources in this example"
  default     = "sasaksacrtest"
}
variable "aks-version" {
  type        = string
  description = "A prefix used for all resources in this example"
  default     = "1.27.9"
}
variable "appId" {
  type        = string
  description = "Azure Kubernetes Service Cluster service principal"
}
variable "password" {
  type        = string
  description = "Azure Kubernetes Service Cluster password"
}
variable "github_token" {
  sensitive = true
  type      = string
}
variable "github_repository" {
  type    = string
  default = "prashantchamps/flux-image-updates"
}
