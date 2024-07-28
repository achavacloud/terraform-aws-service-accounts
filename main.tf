resource "aws_iam_user" "service_account" {
  name = var.user_name
  path = var.user_path
}

resource "aws_iam_user_policy_attachment" "default_policy_attachment" {
  for_each = toset(var.policies)

  user       = aws_iam_user.service_account.name
  policy_arn = each.value
}

resource "aws_iam_user_policy" "deny_console_access" {
  count = var.deny_console_access ? 1 : 0

  user = aws_iam_user.service_account.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": [
        "iam:CreateLoginProfile",
        "iam:UpdateLoginProfile",
        "iam:DeleteLoginProfile",
        "iam:ChangePassword",
        "sts:GetFederationToken",
        "sts:AssumeRole",
        "aws-portal:ViewAccount"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "service_account_key" {
  user = aws_iam_user.service_account.name
}

# # Data source to get the current account ID
# data "aws_caller_identity" "current" {}
#
# resource "aws_iam_user" "users" {
#   for_each = var.users
#
#   name          = each.key
#   path          = var.path
#   force_destroy = var.force_destroy
# }
#
# resource "aws_iam_user_policy_attachment" "default" {
#   for_each = { for user, policies in var.user_policy_attachments :
#     user => user
#   }
#
#   user       = aws_iam_user.users[each.key].name
#   policy_arn = element(var.user_policy_attachments[each.key], 0)
# }
#
# resource "aws_iam_user_policy" "deny_console_login" {
#   for_each = var.users
#
#   name = "${each.key}-deny-console-login"
#   user = aws_iam_user.users[each.key].name
#
#   policy = templatefile("${path.module}/policy_templates/deny_console_login_user.tpl", {
#     account_id = data.aws_caller_identity.current.account_id
#     user_name  = each.key
#   })
# }
#
# resource "aws_iam_group" "groups" {
#   for_each = var.groups
#
#   name = each.key
#   path = var.path
# }
#
# resource "aws_iam_group_policy_attachment" "group_policies" {
#   for_each = { for group, policies in var.group_policy_attachments :
#     group => group
#   }
#
#   group      = aws_iam_group.groups[each.key].name
#   policy_arn = element(var.group_policy_attachments[each.key], 0)
# }
#
# resource "aws_iam_user_group_membership" "group_memberships" {
#   for_each = var.user_group_memberships
#
#   user   = aws_iam_user.users[each.key].name
#   groups = each.value
# }
#
# resource "aws_iam_group_policy" "deny_console_login_group" {
#   for_each = var.groups
#
#   name   = "${each.key}-deny-console-login"
#   group  = aws_iam_group.groups[each.key].name
#
#   policy = templatefile("${path.module}/policy_templates/deny_console_login_group.tpl", {
#     account_id = data.aws_caller_identity.current.account_id
#   })
# }
