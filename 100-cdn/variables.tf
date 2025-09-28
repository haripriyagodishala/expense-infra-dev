variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "frontend_tags" {
    default = {
        Component = "frontend"
    }
}

variable "zone_id" {
    default = "Z093607530ANTLUSW2UYR"
}

variable "zone_name" {
    default = "haridevops.space"
}