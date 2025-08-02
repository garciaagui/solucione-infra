resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

resource "aws_iam_role" "tf-role" {
  name = "tf-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ]
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : [
              "repo:garciaagui/rocketseat-devops:ref:refs/heads/main"
            ]
          }
        }
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::350124735268:oidc-provider/token.actions.githubusercontent.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "tf-role-policy" {
  name = "tf-role-policy"
  role = aws_iam_role.tf-role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Action" : "ecr:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "Statement2",
        "Action" : "iam:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "Statement3",
        "Action" : "s3:*",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
