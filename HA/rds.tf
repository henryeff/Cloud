data "aws_ssm_parameter" "db-password" {
  name = "/rds/password"
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.db-subnet-a.id, aws_subnet.db-subnet-b.id]
  tags = {
    Name = "SRE RDS Subnet Group"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "sre-rds"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.sg-rds.id]
  multi_az               = true
  publicly_accessible    = false
  username               = "rdsadminuser"
  password               = data.aws_ssm_parameter.db-password.value
  skip_final_snapshot    = true

  tags = {
    Name = "SRE RDS Instance Multi-AZ RDS"
  }
}

output "rds_endpoint" {
  value = {
    db_instance_identifier = aws_db_instance.rds.id
    db_instance_endpoint   = aws_db_instance.rds.endpoint
  }
}