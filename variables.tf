variable "TFC_AWS_PLAN_ROLE_ARN" {
  type        = string
  description = "TFC_AWS_PLAN_ROLE_ARN"
}

variable "TFC_AWS_APPLY_ROLE_ARN" {
  type        = string
  description = "TFC_AWS_APPLY_ROLE_ARN"
}

variable "TFC_AWS_RUN_ROLE_ARN" {
  type        = string
  description = "TFC_AWS_RUN_ROLE_ARN"
}

variable "TFC_AWS_PROVIDER_AUTH" {
  default     = true
  description = "TFC_AWS_PROVIDER_AUTH"
}


# s3 vars
variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}
