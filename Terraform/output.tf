output "instance_id" {
    value = aws_instance.byte_instance.id
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_ip" {
    value = aws_instance.byte_instance.public_ip
}
output "private_ip" {
    value = aws_instance.byte_instance.private_ip
}
output "DB_subnet_id"{
    value = aws_db_subnet_group.db_subnet_group.id
}
output "security_group_id" {
  value = aws_security_group.aws_8byte_sg.id
}
