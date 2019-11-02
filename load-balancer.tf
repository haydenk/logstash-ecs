resource "aws_lb_target_group" "logstash-target-group" {
  name = "${var.load-balancer["target_group_name"]}"
  port = "${var.load-balancer["listener_port"]}"
  protocol = "${var.load-balancer["listener_protocol"]}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_lb" "logstash-load-balancer" {
  name = "${var.load-balancer["name"]}"
  load_balancer_type = "${var.load-balancer["type"]}"
  subnets = "${var.subnets}"
}

resource "aws_lb_listener" "logstash-load-balancer-listner" {
  load_balancer_arn = "${aws_lb.logstash-load-balancer.arn}"
  port = "${var.load-balancer["listener_port"]}"
  protocol = "${var.load-balancer["listener_protocol"]}"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.logstash-target-group.arn}"
  }
}
