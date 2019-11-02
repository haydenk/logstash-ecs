data "aws_ecs_task_definition" "logstash_arcsight_task" {
    task_definition = "${aws_ecs_task_definition.logstash_arcsight_task.family}"
    depends_on = ["aws_ecs_task_definition.logstash_arcsight_task"]
}

resource "aws_ecs_task_definition" "logstash_arcsight_task" {
    family = "logstash_task"
    container_definitions = "${file("${path.module}/task_definitions/logstash_arcsight.json")}"
}
