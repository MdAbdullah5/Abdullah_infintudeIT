output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.web.id
}

output "api_gateway_url" {
  value = "${aws_api_gateway_rest_api.api.execution_arn}/courses"
}
