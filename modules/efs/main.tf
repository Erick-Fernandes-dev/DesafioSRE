resource "aws_efs_file_system" "main" {
  creation_token = "${var.desafio_sre}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  
  tags = {
    Name = "${var.desafio_sre}-efs"
  }
}

resource "aws_efs_mount_target" "main" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [var.sg_efs]
}