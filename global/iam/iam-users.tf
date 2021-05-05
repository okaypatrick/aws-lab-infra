resource "aws_iam_user" "test1" {

    name = "test-user-1"
    path = "/"
}

resource "aws_iam_user" "eksadmin" {

    name = "eks-admin"
    path = "/"
}

resource "aws_iam_user" "dle" {

    name = "dle"
    path = "/"
}