resource "aws_launch_configuration" "ecs-launch-configuration" {
  name = "${var.launch-configuration-name}"
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"
  key_name = "${var.ecs-instance-keypair}"
  security_groups = "${var.security-groups}"

  lifecycle {
    create_before_destroy = true
  }

  associate_public_ip_address = true
  user_data_base64 = "${data.template_cloudinit_config.user_data.rendered}"
}

data "template_cloudinit_config" "user_data" {
  part {
    content_type = "text/x-shellscript"
    content = <<EOF
#!/bin/bash
cat <<'EOL' >> /etc/ecs/ecs.config
ECS_CLUSTER=${aws_ecs_cluster.logstash-ecs-cluster.name}
ECS_BACKEND_HOST=
EOL
    EOF
  }
  part {
    content_type = "text/x-shellscript"
    content = <<EOF
#! /bin/bash
cat <<'EOL' >> /home/${var.ecs-instance-user}/.ssh/authorized_keys
${file("${path.module}/authorized_keys")}
EOL
  EOF
  }
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "${var.ecs-autoscaling-group-name}"
  max_size = "${var.auto_scaling["max_size"]}"
  min_size = "${var.auto_scaling["min_size"]}"
  desired_capacity = "${var.auto_scaling["desired_capacity"]}"

  vpc_zone_identifier = "${var.subnets}"
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type = "ELB"

  target_group_arns = ["${aws_lb_target_group.logstash-target-group.arn}"]
  service_linked_role_arn = "arn:aws:iam::068858810320:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"  
}

resource "aws_ecs_cluster" "logstash-ecs-cluster" {
  name = "${var.ecs-cluster-name}"

  tags = {
    Name = "ECS Logstash"
  }
}