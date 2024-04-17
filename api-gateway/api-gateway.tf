resource "aws_api_gateway_rest_api" "courses-api" {
  name        = "my-api"
  description = "My API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  parent_id   = aws_api_gateway_rest_api.courses-api.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  parent_id   = aws_api_gateway_rest_api.courses-api.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_resource" "course_id" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "id"
}

resource "aws_api_gateway_method" "post_proxy" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = "POST"
  authorization = "NONE"
  
}

resource "aws_api_gateway_method" "get_all_courses" {
  rest_api_id   = aws_api_gateway_rest_api.courses-api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_all_authors" {
  rest_api_id   = aws_api_gateway_rest_api.courses-api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses-api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "put_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses-api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "delete_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses-api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_request_validator" "validator" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  name        = "ValidateBody"
  validate_request_body = true
}

resource "aws_api_gateway_integration" "post_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.post_proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:save-course/invocations" 
}

resource "aws_api_gateway_integration" "get_all_courses_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get_all_courses.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:get-all-courses/invocations"
}

resource "aws_api_gateway_integration" "get_all_authors_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_all_authors.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:get-all-authors/invocations"
}

resource "aws_lambda_permission" "apigw_get_all_authors" {
  statement_id  = "AllowAPIGatewayInvokeAuthors"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:eu-central-1:767397787090:function:get-all-authors"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "apigw_get_all_courses" {
  statement_id  = "AllowAPIGatewayInvokeGetAllCourses"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:eu-central-1:767397787090:function:get-all-courses"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_integration" "get_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:get-course/invocations"
}

resource "aws_api_gateway_integration" "get_authors_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_all_authors.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:get-course/invocations"
}

resource "aws_api_gateway_integration" "put_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.put_course.http_method
  integration_http_method = "PUT"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:update-course/invocations"

request_templates = {
    "application/json" = jsonencode({
      "id": "$input.params('id')",
      "title" : "$input.json('$.title')",
      "authorId" : "$input.json('$.authorId')",
      "length" : "$input.json('$.length')",
      "category" : "$input.json('$.category')",
      "watchHref" : "$input.json('$.watchHref')"
    })
  }
}

resource "aws_api_gateway_integration" "delete_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses-api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-central-1:lambda:path/2024-04-06/functions/arn:aws:lambda:eu-central-1:767397787090:function:delete-course/invocations"
}

resource "aws_api_gateway_method_response" "post_proxy_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.post_proxy.http_method
  status_code = "200"
    response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.post_proxy]
}

resource "aws_api_gateway_method_response" "get_all_courses_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = "200"

   response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.get_all_courses]
}

resource "aws_api_gateway_method_response" "get_all_authors_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_all_authors.http_method
  status_code = "200"

   response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.get_all_authors]
}

resource "aws_api_gateway_method_response" "get_course_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = "200"
    response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.get_course]
}

resource "aws_api_gateway_method_response" "put_course_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = "200"
    response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.put_course]
}

resource "aws_api_gateway_method_response" "delete_course_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = "200"

    response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.delete_course]
}

resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.post_proxy.http_method
  status_code = aws_api_gateway_method_response.post_proxy_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}

  depends_on = [
    aws_api_gateway_method.post_proxy,
    aws_api_gateway_integration.post_lambda_integration
  ]
}

resource "aws_api_gateway_integration_response" "get_all_courses_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = aws_api_gateway_method_response.get_all_courses_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}

  depends_on = [
    aws_api_gateway_method.get_all_courses,
    aws_api_gateway_integration.get_all_courses_integration
  ]
}

resource "aws_api_gateway_integration_response" "get_all_authors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.get_all_authors.http_method
  status_code = aws_api_gateway_method_response.get_all_authors_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}

  depends_on = [
    aws_api_gateway_method.get_all_authors,
    aws_api_gateway_integration.get_all_authors_integration
  ]
}

resource "aws_api_gateway_integration_response" "get_course_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course_response.status_code

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
      "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.get_course,
    aws_api_gateway_integration.get_course_integration
  ]
}

resource "aws_api_gateway_integration_response" "put_course_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = aws_api_gateway_method_response.put_course_response.status_code

    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
      "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.put_course,
    aws_api_gateway_integration.put_course_integration
  ]
}

resource "aws_api_gateway_integration_response" "delete_course_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses-api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course_response.status_code

    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
      "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.delete_course,
    aws_api_gateway_integration.delete_course_integration
  ]
}


