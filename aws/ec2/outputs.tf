output "ec2_instance" {
    value = aws_instance.my_instance.id
}

output "elastic_ip" {
    value = aws_eip.my_eip.address
}