#Main vpc for the sokoshopper project
resource "aws_vpc""main_network"{
    cidr_block = "10.0.0.0/16"

    tags       = {
        Name   = "SokoShopper-Network"
    }
}

#Private subnet for the main vpc to host the ec2 instances in a private subnet.
resource "aws_subnet""private_subnet"{
    vpc_id     = aws_vpc.main_network.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-central-1b"

    tags       = {
        Name   = "SokoShopper-private-network"
    }
}

#Public subnet A for the ELB to failover to.
resource "aws_subnet""public_subnet_A"{
    vpc_id     = aws_vpc.main_network.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-central-1b"


    tags       = {
        Name   = "SokoShopper-publicA-network"
    }
}

#Public subnet B for the ELB to failover
resource "aws_subnet""public_subnet_B"{
    vpc_id     = aws_vpc.main_network.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-central-1c"

    tags       = {
        Name   = "SokoShopper-publicB-network"
    }
}

#Configuring the internet gateway to route traffic out of the VPC
resource "aws_internet_gateway""main_gw"{
    vpc_id     = aws_vpc.main_network.id
    tags       = {
        Name   = "SokoShopper Internet gateway"
    }
}

resource "aws_route_table""private_rtbl"{
    vpc_id     = aws_vpc.main_network.id

    route{
        cidr_block   = "0.0.0.0/0"
        gateway_id   = aws_nat_gateway.private_nat_gw.id
    }

    tags ={
        Name         = "SokoShopper-private-rtbl"
    }

    depends_on       = [aws_nat_gateway.private_nat_gw]
}

#Route table for the public subnets 
resource "aws_route_table""public_rtbl"{
    vpc_id     = aws_vpc.main_network.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_gw.id
    }

    tags = {
        Name       = "SokoShopper-public-rtbl"
    }
}

#Creating the elastic IP for the nat gateway
resource "aws_eip""nat_gateway_eip"{
    vpc        = true
    depends_on = [aws_internet_gateway.main_gw]

    tags  = {
        Name   = "Sokoshopper-EIP"
    }
}

#Nat gateway being provisioned in the public subnet i.e public subnet A
resource "aws_nat_gateway""private_nat_gw"{
    allocation_id  = aws_eip.nat_gateway_eip.id
    subnet_id      = aws_subnet.public_subnet_A.id

    tags = {
        Name       = "Sokoshopper-nat-gateway"
    }
}

#Associating the public subnet to its route table
resource "aws_route_table_association""asociation_public_sub_a"{
    subnet_id      = aws_subnet.public_subnet_A.id
    route_table_id = aws_route_table.public_rtbl.id
}

#Associating the public subnet to its route table
resource "aws_route_table_association""asociation_public_sub_b"{
    subnet_id      = aws_subnet.public_subnet_B.id
    route_table_id = aws_route_table.public_rtbl.id
}

#Associating the public subnet to its route table
resource "aws_route_table_association""asociation_private_sub"{
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rtbl.id
}

#Creating the security group for both api and frontend
resource "aws_security_group" "allow_http_https" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main_network.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sokoshopper_project"
  }
}

#Assigning the route tables of public subnet A as the main
# resource "aws_main_route_table_association" "public_sub_assoc_A" {
#   vpc_id         = aws_vpc.main_network.id
#   route_table_id = aws_route_table_association.asociation_public_sub_a.id

#   depends_on     = [aws_route_table_association.asociation_public_sub_a]
# }

# #Assigning the route tables public subnet B as the main
# resource "aws_main_route_table_association" "public_sub_assoc_B" {
#   vpc_id         = aws_vpc.main_network.id
#   route_table_id = aws_route_table_association.asociation_public_sub_b.id

#   depends_on     = [aws_route_table_association.asociation_public_sub_b]
# }

# #Assigning the route tables for private subnet as the main
# resource "aws_main_route_table_association" "public_sub_assoc_C" {
#   vpc_id         = aws_vpc.main_network.id
#   route_table_id = aws_route_table_association.asociation_private_sub.id

#   depends_on     = [aws_route_table_association.asociation_private_sub]
# }