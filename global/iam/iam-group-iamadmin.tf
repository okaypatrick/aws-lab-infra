locals {
  iam_admin_users = [
    aws_iam_user.test1.name,
  ]
}

resource "aws_iam_group" "iam_admins" {

    name = "IAM-Administrators"
    path = "/"

}

resource "aws_iam_group_membership" "iam_admins_membership" {

    name = "iam_admins"
    group = aws_iam_group.iam_admins.name
    users = local.iam_admin_users

}

#this policy document specifies read only access for IAM admins
data "aws_iam_policy_document" "read_only" {

  statement {

    sid = "EC2ReadOnly"
    effect = "Allow"
    actions = [

      "ec2:DescribeInstances",
      "ec2:DescribeImages",
      "ec2:DescribeTags",
      "ec2:DescribeSnapshots"
      
    ]
    resources = ["*"]

  }

}


#[to-do] was this for permission boundaries or just to allow users to create/delete IAM users?
#https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_delegate-permissions_examples.html


data "aws_iam_policy_document" "user_admin" {

  statement {

    sid = "AllowUsersToPerformActions"

    effect = "Allow"

    actions = [

      "iam:ListPolicies",
      "iam:GetPolicy",
      "iam:UpdateUser",
      "iam:AttachUserPolicy",
      "iam:ListEntitiesForPolicy",
      "iam:DeleteUserPolicy",
      "iam:DeleteUser",
      "iam:ListUserPolicies",
      "iam:CreateUser",
      "iam:RemoveUserFromGroup",
      "iam:AddUserToGroup",
      "iam:GetUserPolicy",
      "iam:ListGroupsForUser",
      "iam:PutUserPolicy",
      "iam:ListAttachedUserPolicies",
      "iam:ListUsers",
      "iam:GetUser",
      "iam:DetachUserPolicy"

    ]
    resources = ["*"]

  }

}
resource "aws_iam_group_policy" "read_only_policy" {

  name = "ec2_read_only_policy"

  #associate IAM admins group to this read-only policy
  group = aws_iam_group.iam_admins.name

  policy = data.aws_iam_policy_document.read_only.json



}

resource "aws_iam_group_policy" "user_admin_policy" {

  name = "iam_user_admin_policy"

  #associate IAM admins group to user admin policy
  group = aws_iam_group.iam_admins.name

  policy = data.aws_iam_policy_document.user_admin.json



}