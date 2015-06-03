resource "aws_security_group" "database" {
  name = "${var.environment}-${var.db_identifer_suffix}"
  description = "RDS database security group"

  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["${split(",", var.admin_cidrs)}"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment} RDS group"
    environment = "${var.environment}"
    project = "${var.project}"
    product = "${var.product}"
  }

  vpc_id = "${var.vpc_id}"
}

resource "aws_db_subnet_group" "default" {
    name = "${var.environment}-${var.db_identifer_suffix}"
    description = "RDS subnet group"
    subnet_ids = ["${split(",", var.vpc_subnet_ids)}"]
}

resource "aws_db_instance" "default" {
    depends_on = ["aws_db_subnet_group.default", "aws_security_group.database"]
    identifier = "${var.environment}-${var.db_identifer_suffix}"
    allocated_storage = "${var.db_storage_size}"
    engine = "${var.db_engine}"
    engine_version = "${var.db_engine_version}"
    instance_class = "${var.db_instance_size}"
    username = "${var.db_admin_username}"
    password = "${var.db_admin_password}"
    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
    parameter_group_name = "${var.db_parameter_group}"
    final_snapshot_identifier = "${var.environment}-${var.db_identifer_suffix}"
    backup_retention_period = "${var.db_backup_retention_period}"
    backup_window = "${var.db_backup_window}"
    maintenance_window = "${var.db_maintenance_window}"
    multi_az = "${var.db_multi_az}"
    vpc_security_group_ids = ["${aws_security_group.database.id}"]
    publicly_accessible = true
    lifecycle {
      prevent_destroy = true
    }
}
