# resource "aws_eks_cluster" "eks_clusters" {
#   for_each = var.eks_clusters

#   name     = each.value.name
#   role_arn = aws_iam_role.eks_cluster_role.arn

#   vpc_config {
#     subnet_ids = [for s in aws_subnet.subnet : s.id]
#   }

#   depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
# }

# resource "aws_eks_node_group" "node_groups" {
#   for_each = var.eks_node_groups

#   cluster_name    = each.value.cluster_name
#   node_group_name = each.value.node_group_name
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = [for s in aws_subnet.subnet : s.id]

#   scaling_config {
#     desired_size = each.value.min_nodes
#     max_size     = each.value.max_nodes
#     min_size     = each.value.min_nodes
#   }

#   instance_types = [each.value.node_instance_type]

#   depends_on = [aws_eks_cluster.eks_clusters]
# }