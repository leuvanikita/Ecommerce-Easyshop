output "ec2_public_dns" {

  description = "Public DNS"
  value       = aws_instance.ecommerce_instance.public_ip
}

output "region" {

  description = "AWS Region"
  value = var.aws_region 
}

output "eks_cluster_name" {

  description = "EKS Cluster Name"
  value = module.eks.cluster_name 
}

output "eks_node_group_public_ips" {
  
  description = "EKS Nodegroup public ip "
  value = module.eks.cluster_name 
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}
