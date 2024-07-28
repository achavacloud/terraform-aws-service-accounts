Terraform AWS IAM Service Accounts Module

Overview
This Terraform module facilitates the creation and management of AWS IAM service accounts with specific policies. It is designed for use cases where service accounts are needed for automation tools like Terraform or Jenkins, and console access needs to be restricted.
Features

- IAM Users: Create IAM users specifically for service accounts.
- Policy Attachments: Attach managed or custom policies to IAM users to grant specific permissions.
- Console Access Restriction: Optionally deny console access to service accounts, ensuring they can only interact with AWS programmatically.
- Access Keys: Generate access keys for programmatic access.

###### This module structure and configuration allow users to create a VPC with customizable settings, including region, subnets, and security configurations. The use of variables makes the module flexible and reusable across different projects and environments. Users can provide their specific values for the variables in a terraform.tfvars file or through other methods, ensuring the infrastructure meets their specific needs.

```sh
terraform-aws-iam-users/
├── main.tf          # Core resource and data definitions
├── variables.tf     # Input variable definitions
├── outputs.tf       # Output definitions
└── README.md        # Documentation 
```

**main.tf**
```hcl
module "terraform_service_account" {
  source              = ""
  user_name           = "terraform-service-account"
  user_path           = "/service-accounts/"
  policies            = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  deny_console_access = true
}
```
**outputs.tf**
```hcl
output "role_id" {
  description = "The ID of the IAM role."
  value       = aws_iam_role.this.id
}

output "role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.this.arn
}

output "policy_id" {
  description = "The ID of the IAM policy."
  value       = aws_iam_role_policy.this.id
}
```
**terraform.tfvars**
```hcl
user_name           = "<user_name>"
user_path           = "/"
policies            = ["<aws_policy_arn_necessary>"]
deny_console_access = true/false
```
**variables.tf**
```hcl
variable "role_name" {
  description = "The name of the IAM role."
  type        = string
}

variable "assume_role_statements" {
  description = "List of assume role policy statements."
  type = list(object({
    effect                = string
    actions               = list(string)
    resources             = optional(list(string), ["*"])
    principal_type        = string
    principal_identifiers = list(string)
    conditions            = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
}

variable "policy_name" {
  description = "The name of the IAM policy attached to the role."
  type        = string
}

variable "policy_statements" {
  description = "A list of policy statements for the role's policy."
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
}

variable "tags" {
  description = "A map of tags to assign to the role."
  type        = map(string)
  default     = {}
}
```
