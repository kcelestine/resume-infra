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
