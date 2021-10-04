provider "aws" {
    region     = "eu-central-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

module "creating_vpc" {
    source     = "./modules/vpc"
}

module "creating_instances" {
    source     = "./modules/instance"
    main_network = module.creating_vpc.vpc_id
    private_subnet = module.creating_vpc.private_subnet_id
    security_groups = module.creating_vpc.security_group
    asg_availability = "eu-central-1a"
}

module "creating_autoscaling_groups" {
    source = "./modules/autoscaling"
    security_group    = module.creating_vpc.security_group
    subnet1           = module.creating_vpc.public_subnet_id
    subnet2           = module.creating_vpc.public_subnetB_id
    target_group_arn  = module.creating_alb.target_group
}

module "creating_alb" {
    source   = "./modules/elb"
    main_vpc = module.creating_vpc.vpc_id
    subnet1  = module.creating_vpc.private_subnet_id
    subnet2  = module.creating_vpc.public_subnet_id
    security_group = module.creating_vpc.security_group
}