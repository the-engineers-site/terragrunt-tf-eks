variable "environment_name" {
  type     = string
  nullable = false
}

variable "vpc" {
  type = object({
    cidr       = string
    no_of_nats = number
  })
  nullable = false
}

variable "tags" {
  type = map(string)
}

variable "eks" {
  type = object({
    cluster_name_suffix = string
    eks_service_cidr    = string
    version             = object({
      eks = string
    })
  })
}