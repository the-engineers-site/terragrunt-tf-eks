variable "eks_cluster_id" {
  default = ""
}
variable "eks_version" {
  default = ""
}

variable "eks_cluster_certificate_authority_data" {
  default = ""
}

variable "tags" {
  type = map(string)
}