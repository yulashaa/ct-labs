module "label" {
  source   = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
}

module "lambda_function1" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = "get-all-authors"
  description   = "lambda function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/get-all-authors"

}

 module "lambda_function2" {
   source = "terraform-aws-modules/lambda/aws"
   version = "7.2.3"

   function_name = "get-all-courses"
   description   = "lambda function"
   handler       = "index.handler"
   runtime       = "nodejs16.x"

   source_path = "${path.module}/src/get-all-courses"

 }

 module "lambda_function3" {
   source = "terraform-aws-modules/lambda/aws"
   version = "7.2.3"

   function_name = "get-course"
   description   = "lambda function"
   handler       = "index.handler"
   runtime       = "nodejs16.x"

   source_path = "${path.module}/src/get-course"

 }

module "lambda_function4" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = "save-course"
  description   = "lambda function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/save-course"
}

module "lambda_function5" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = "update-course"
  description   = "lambda function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/update-course"
}


module "lambda_function6" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = "delete-course"
  description   = "lambda function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/delete-course"
}
