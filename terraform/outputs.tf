output "vpc_id" {
  value = aws_vpc.test.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.pub_a.id,
    aws_subnet.pub_c.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.pri_a.id,
    aws_subnet.pri_c.id
  ]
}

output "ecr_repository_url" {
  value = aws_ecr_repository.petclinic.repository_url
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "rds_endpoint" {
  value = aws_db_instance.tf-db.endpoint
}
