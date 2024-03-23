#resource "kubernetes_secret" "main" {
#  metadata {
#    name      = "regsecret"
#    namespace = "flux-system"
#  }
#
#  type = "kubernetes.io/dockerconfigjson"
#
#  data = {
#    ".dockerconfigjson" = jsonencode({
#      auths = {
#        "${var.registry_server}" = {
#          "username" = var.appId
#          "password" = var.password
#          "auth"     = base64encode("${var.appId}:${var.password}")
#        }
#      }
#    })
#  }
#
#  depends_on = [
#    flux_bootstrap_git.main,
#    azurerm_kubernetes_cluster.main,
#    azurerm_container_registry.main
#  ]
#}
