output "db_endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "db_id" {
  value = "${aws_db_instance.default.id}"
}

output "security_group_id" {
  value = "${aws_security_group.database.id}"
}
