output "endpoint" {
  value = aws_db_instance.default.address
}

output "name" {
  value = aws_db_instance.default.name
}

output "username" {
  value = aws_db_instance.default.username
}
