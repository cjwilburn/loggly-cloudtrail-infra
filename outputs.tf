output "loggly_s3_bucket_name" {
    value = "${aws_s3_bucket.main_trail.id}"
}
output "loggly_aws_access_key_id" {
    value = "${aws_iam_access_key.loggly.id}"
}
output "loggly_aws_secret_access_key" {
    value = "${aws_iam_access_key.loggly.secret}"
}
