output "vpc_id" {
    value = aws_vpc.main_network.id
}

output "private_subnet_id" {
    value = "${aws_subnet.private_subnet.id}"
}

output "public_subnet_id" {
    value = "${aws_subnet.public_subnet_B.id}"
}

output "public_subnetB_id" {
    value = "${aws_subnet.public_subnet_A.id}"
}

output "security_group" {
    value = ["${aws_security_group.allow_http_https.id}"]
}

output "subnet1" {
    value = "aws_subnet.private_subnet.id"
}