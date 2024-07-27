variable "aws_region" {
  type = string
}
variable "user_name" {
  description = "The name of the IAM user to create."
  type        = string
}

variable "user_path" {
  description = "The path for the IAM user. This can be used to organize users in a hierarchical structure."
  type        = string
  default     = "/"
}

variable "policies" {
  description = "A list of IAM policy ARNs to attach to the user. This determines the permissions the user will have."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

variable "deny_console_access" {
  description = "Whether to attach a policy that denies console access to the user."
  type        = bool
  default     = true
}