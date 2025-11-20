output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.eks_vpc.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.eks.arn
}

output "eks_node_group_name" {
  description = "EKS Node Group Name"
  value       = aws_eks_node_group.demo_nodes.node_group_name
}

output "eks_node_group_arn" {
  description = "EKS Node Group ARN"
  value       = aws_eks_node_group.demo_nodes.arn
}

output "cluster_autoscaler_irsa_role_arn" {
  description = "IAM Role ARN for Cluster Autoscaler IRSA"
  value       = aws_iam_role.cluster_autoscaler_irsa.arn
}

output "environment" {
  description = "The environment this EKS cluster belongs to"
  value       = var.environment
}