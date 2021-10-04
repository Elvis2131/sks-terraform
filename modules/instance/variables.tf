variable "main_network" {
    #type = string
    description = "Main network's id"
}

variable "private_subnet" {
    # type = string
    description = "Private subnet for the intances to be launched!"
}

variable "security_groups" {
    #stype = string
    description = "Security groups"
}

variable "asg_availability" {
    # type = string
    # description = "(optional) describe your variable"
}