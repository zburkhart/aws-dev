# resource "helm_release" "prometheus" {
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus"
#   version    = "17.1.0"

#   depends_on = [
#     aws_eks_cluster.eks_clusters
#   ]
# }

# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   version    = "6.48.0"

#   depends_on = [
#     aws_eks_cluster.eks_clusters
#   ]
# }
