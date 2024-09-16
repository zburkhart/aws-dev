# # Define the EKS cluster
# resource "aws_eks_cluster" "eks" {
#   name     = "my-eks-cluster"
#   role_arn = aws_iam_role.eks_cluster_role.arn
#   version  = "1.21"

#   vpc_config {
#     subnet_ids = aws_subnet.subnet[*].id
#   }

#   tags = {
#     Name = "my-eks-cluster"
#   }
# }

# # Define node group
# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name    = aws_eks_cluster.eks.name
#   node_group_name = "eks-node-group"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = aws_subnet.subnet[*].id
#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }

#   tags = {
#     Name = "eks-node-group"
#   }
# }