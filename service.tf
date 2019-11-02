resource "aws_ecs_service" "logstash-arcsight-service" {
  name = "logstash-arcsight-service"
  cluster = "${aws_ecs_cluster.logstash-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.logstash_arcsight_task.family}:${max("${aws_ecs_task_definition.logstash_arcsight_task.revision}", "${data.aws_ecs_task_definition.logstash_arcsight_task.revision}")}"
  desired_count = 2
  iam_role = "${aws_iam_role.ecs-service-role.name}"
  load_balancer {
      target_group_arn = "${aws_lb_target_group.logstash-target-group.id}"
      container_name = "logstash-arcsight"
      container_port = "${var.load-balancer["listener_port"]}"
  }
  depends_on = ["aws_lb_listener.logstash-load-balancer-listner"]
}
