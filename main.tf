variable "profile" { type = "string" }
variable "ecs-instance-role-name" {
  type = "string"
  default = "LogstashECSInstanceRole"
}
variable "ecs-service-role-name" {
  type = "string"
  default = "LogstashECSServiceRole"
}
variable "ecs-instance-policy-name" {
  type = "string"
  default = "LogstashECSInstancePolicy"
}
variable "ecs-instance-profile-name" {
  type = "string"
  default = "logstash-instance-profile"
}
variable "launch-configuration-name" {
  type = "string"
  default = "logstash-launch-configuration"
}
variable "ecs-autoscaling-group-name" {
  type = "string"
  default = "logstash-poc-scaling-group"
}
variable "ecs-cluster-name" {
  type = "string"
  default = "logstash-poc-csm-cluster"
}
variable "ecs-instance-user" {
  type =  "string"
  default = "ec2-user"
}
variable "ecs-instance-keypair" {
  type = "string"
  default = "csm_access"
}
variable "region" {
  type = "string"
  default = "us-east-1"
}
variable "image_id" {
  type = "string"
  default = "ami-0d2f82a622136a696"
}
variable "instance_type" {
  type = "string"
  default = "t2.medium"
}
variable "load-balancer" {
  type = "map"
  default = {
    name = "logstash-poc-csm-load-balancer"
    listener_port = 1337
    listener_protocol = "TCP"
    type = "network"
    target_group_name = "logstash-poc-csm-target-group"
  }
}
variable "vpc_id" { type ="string" }
variable "subnets" { type = "list" default = [] }
variable "security-groups" { type = "list" default = [] }
variable "auto_scaling" {
  type = "map"
  default = {
    max_size = 2
    min_size = 1
    desired_capacity = 2
  }
}
provider "aws" {
  profile = "${var.profile}"
  region = "${var.region}"
}
