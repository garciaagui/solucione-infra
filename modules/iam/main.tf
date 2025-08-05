resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
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
              "repo:garciaagui/solucione-infra:ref:refs/heads/main"
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

resource "aws_iam_role" "ecr-role" {
  name = "ecr-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::350124735268:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ]
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : [
              "repo:garciaagui/solucione-backend:ref:refs/heads/main"
            ]
          }
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

resource "aws_iam_role_policy" "ecr-role-policy" {
  name = "ecr-role-policy"
  role = aws_iam_role.ecr-role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Action" : "apprunner:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "Statement2",
        "Action" : [
          "iam:PassRole",
          "iam:CreateServiceLinkedRole",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "Statement3",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
        ]
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
