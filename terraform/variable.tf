variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used to name/tag all resources"
  type        = string
  default     = "three-tier-devsecops"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.34"
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for the Jenkins/DevSecOps tooling server"
  type        = string
  default     = "t3.small"
}

variable "key_pair_name" {
  description = "Name of an EXISTING EC2 key pair used for SSH access to the Jenkins server"
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR form, e.g. 203.0.113.10/32"
  type        = string
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "jenkins_ami_id" {
  description = "Custom AMI ID from a pre-configured golden Jenkins box. Leave empty for now."
  type        = string
  default     = ""
}

variable "enable_monitoring" {
  type    = bool
  default = true
}
