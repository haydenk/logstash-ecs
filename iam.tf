resource "aws_iam_role" "ecs-instance-role" {
  name               = "${var.ecs-instance-role-name}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}

resource "aws_iam_role" "ecs-service-role" {
  name               = "${var.ecs-service-role-name}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logstash-policy" {
  statement {
    actions = [
      "es:*",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs-instance-policy" {
  name   = "${var.ecs-instance-policy-name}"
  role   = "${aws_iam_role.ecs-instance-role.id}"
  policy = "${data.aws_iam_policy_document.logstash-policy.json}"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "${var.ecs-instance-profile-name}"
  path = "/"
  role = "${aws_iam_role.ecs-instance-role.id}"
}
resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
