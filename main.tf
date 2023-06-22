resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = var.role_arn

  version = var.k8s_version

  vpc_config {
    endpoint_private_access = var.vpc_config["endpoint_private_access"]
    endpoint_public_access  = var.vpc_config["endpoint_public_access"]
    subnet_ids              = var.vpc_config["subnet_ids"]
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_eks_node_group" "node_group" {
  for_each = var.nodegroup_list

  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = each.value["node_group_name"]
  node_role_arn   = var.role_arn
  subnet_ids      = each.value["subnet_ids"]
  disk_size       = each.value["disk_size"]
  instance_types  = each.value["instance_types"]

  remote_access {
    ec2_ssh_key = each.value["remote_access"]["ec2_ssh_key"]
    source_security_group_ids = [var.nodegroup_sg_ids]
  }

  scaling_config {
    desired_size = each.value["scaling_config"]["desired_size"]
    max_size     = each.value["scaling_config"]["max_size"]
    min_size     = each.value["scaling_config"]["min_size"]
  }
  
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

}
