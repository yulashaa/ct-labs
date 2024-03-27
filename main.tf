module "s3" {
  source = "./modules/s3"
  bucket_name = "${data.aws_caller_identity.current.account_id}-terraform-my-test-bucket-${data.aws_caller_identity.current.account_id}"
}

module "table_authors" {
   source = "./modules/dynamodb"
  context = module.label.context
  name = "authors"
}

module "table_courses" {
  source = "./modules/dynamodb"
  context = module.label.context
  name = "courses"
}

module "lambdas" {
  source = "./modules/lambda"
  context = module.label.context
  table_authors_name = module.table_authors.id
}
