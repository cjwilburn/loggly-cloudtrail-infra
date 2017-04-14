provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.trail_name}"
  s3_bucket_name                = "${aws_s3_bucket.main_trail.id}"
  # s3_key_prefix                 = "prefix"
  include_global_service_events = true
  enable_log_file_validation = true
  is_multi_region_trail = true
  sns_topic_name = "${aws_sns_topic.main_trail.id}"
}

resource "aws_sns_topic" "main_trail" {
  name = "${var.bucket_name}"
}

resource "aws_s3_bucket" "main_trail" {
  bucket        = "${var.bucket_name}"
  acl = "private"
  # force_destroy = true
  tags {
    Name = "CloudTrail logs"
    builtWith = "terraform"
  }
}
resource "aws_s3_bucket_policy" "main_trail" {
  bucket = "${aws_s3_bucket.main_trail.id}"
  policy = "${data.aws_iam_policy_document.main_trail.json}"
}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "main_trail" {
  statement {
    sid = "AWSCloudTrailAclCheck20150319"
    principals {
      type  = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "${aws_s3_bucket.main_trail.arn}"
    ]
  }
  # Allow Write
  statement {
    sid = "AWSCloudTrailWrite20150319"
    principals {
      type  = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.main_trail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
    condition = {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}

# define loggly user and policy
resource "aws_iam_user" "loggly" {
    name = "${var.user_name}"
}
resource "aws_iam_user_policy" "loggly" {
  name = "loggly_cloudtrail"
  user = "${aws_iam_user.loggly.name}"

  policy = "${data.aws_iam_policy_document.loggly.json}"
}
data "aws_iam_policy_document" "loggly" {
  # allow read access to s3 bucket
  statement {
      sid = "1"
      actions = [
        "s3:ListBucket",
        "s3:GetObject"
      ]
      resources = [
        "${aws_s3_bucket.main_trail.arn}",
        "${aws_s3_bucket.main_trail.arn}/*"
      ]
  }
}

# generate access key for loggly user
resource "aws_iam_access_key" "loggly" {
    user = "${aws_iam_user.loggly.name}"
}
