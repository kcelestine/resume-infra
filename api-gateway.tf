resource "aws_api_gateway_deployment" "example" {
  rest_api_id = "${aws_api_gateway_rest_api.resume_api_gateway.id}"
  stage_name  = "prod"
}
