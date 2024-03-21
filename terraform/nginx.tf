resource "helm_release" "external_nginx" {
  name = "external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "default"
  create_namespace = false
  version          = "4.8.0"

  values = [file("${path.module}/values/ingress.yaml")]
}
