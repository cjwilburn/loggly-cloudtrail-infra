# Required

# Optional
variable "user_name" {
  description = "Name of User"
  default     = "loggly-trails-user"
}

variable "bucket_name" {
  description = "Name of S3 bucket"
  default     = "my-trails-bucket"
}

variable "trail_name" {
  description = "Name of CloudTrail trail"
  default     = "my-main-trail"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-southeast-1"
}
