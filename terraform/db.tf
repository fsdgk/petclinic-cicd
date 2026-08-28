resource "aws_security_group" "db" {
  name        = var.db_security_group_name
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.test.id

  ingress {
    description     = "MySQL from EKS cluster"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.main.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.db_security_group_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "tf-db" {
  name = "${var.project_name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.pri_a.id,
    aws_subnet.pri_c.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "tf-db" {
  identifier             = var.db_identifier
  allocated_storage      = var.db_allocated_storage
  engine                 = "mysql"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.tf-db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  multi_az               = true
}
