resource "aws_api_gateway_model" "CourseInputModel" {
    
  rest_api_id  = aws_api_gateway_rest_api.courses-api.id
  name         = "CourseInputModel"
  description  = "JSON schema"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" : "http://json-schema.org/schema#",
    "title" : "CourseInputModel",
    "type" : "object",
    "properties" : {
      "title" : {"type" : "string"},
      "authorId" : {"type" : "string"},
      "length" : {"type" : "string"},
      "category" : {"type" : "string"}
    },
    "required" : ["title", "authorId", "length", "category"]
  })
}