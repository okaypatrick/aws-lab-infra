output "iam_admins_group_arn" {
   
    value = aws_iam_group.iam_admins.arn
}

output "eks_admins_group_arn" {

    value = aws_iam_group.eks_admins.arn
}