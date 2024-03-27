output "bucket_id" {
    value = aws_s3_bucket.this.id
}

output "my_best_arn" {
    value = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
    value = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.this.bucket_regional_domain_name 
}