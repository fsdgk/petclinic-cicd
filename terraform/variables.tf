variable "project_name" {
  description = "Project name used for resource names."
  type        = string
}

variable "db_security_group_name" {
  description = "The name of the security group for the database."
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "db_username" {
  description = "Database admin username."
  type        = string
}

variable "db_password" {
  description = "Database admin password."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS storage size in GiB."
  type        = number
}

variable "ecr_repository_name" {
  description = "ECR repository name for the PetClinic image."
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "eks_node_group_name" {
  description = "EKS managed node group name."
  type        = string
}

variable "eks_node_instance_types" {
  description = "EC2 instance types for EKS worker nodes."
  type        = list(string)
}

variable "eks_node_desired_size" {
  description = "Desired number of EKS worker nodes."
  type        = number
}

variable "eks_node_min_size" {
  description = "Minimum number of EKS worker nodes."
  type        = number
}

variable "eks_node_max_size" {
  description = "Maximum number of EKS worker nodes."
  type        = number
}
