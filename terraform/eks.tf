module "eks" {
  # import the module template
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # cluster information (control plane)
  cluster_name    = var.cluster_name
  cluster_version = var.k8s_version

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
  depends_on               = [module.vpc]

  cluster_addons = {
    coredns = {
      most-recent = true
    }

    kube-proxy = {
      most-recent = true
    }

    vpc-cni = {
      most-recent = true
    }
  }

  eks_managed_node_group_defaults = {
    instance_types = ["t2.large"]

    attach_cluster_primary_security_group = true
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    terra-cluster-ng = {
      Name = "${var.cluster_name}-ng"

      instance_types = [var.eks_node_instance_type]

      min_size      = 2
      max_size      = 3
      desired_size  = 2
      capacity_type = "SPOT" # 2 types: on spot & demand
      disk_size     = 35

      tags = {
        Environment = var.env
        Terraform   = "true"
      }

      launch_template_tags = {
        Name = "${var.cluster_name}-ng"
      }
      use_custom_launch_template = true # Important to visibke tag name on node group

    }
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.env
    Terraform   = "true"
  }
}
