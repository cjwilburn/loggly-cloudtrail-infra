# Terraform configuration for Loggly CloudTrail log ingestion

This Terraform configuration automates the [AWS configuration for CloudTrail log ingestion into Loggly](https://www.loggly.com/docs/cloudtrail-log-ingestion/).


## Pre-Requisites

To use this Terraform configuration:

Install [Terraform](https://www.terraform.io/downloads.html) (tested with 0.9.3) and [aws-cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html), also complete your aws-cli [configuration](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

## Variables

Following variables are available for customisation:

| Name            | Description            | Default               |
| --------------- | ---------------------- | --------------------- |
| `aws_region`    | The AWS region to use  | `ap-southeast-1`      |
| `user_name`     | Name of User           | `loggly-trails-user`  |
| `bucket_name`   | Name of S3 bucket      | `my-trails-bucket`    |
| `trail_name`    | Name of Trail          | `my-main-trail`       |

```bash
# through env vars
export TF_VAR_aws_region=ap-southeast-1
export TF_VAR_user_name=loggly-s3-user
export TF_VAR_bucket_name=my-bucket
export TF_VAR_trail_name=my-main-trail

# or through variable file
curl -Lo terraform.tfvars https://raw.githubusercontent.com/honestbee/loggly-cloudtrail-infra/master/terraform.tfvars.example
```

## Usage

Clone this repository or run directly from git:

```bash
terraform init github.com/honestbee/loggly-cloudtrail-infra
```

### Planning changes

Use `terraform plan` to preview changes this configuration will apply to your AWS account:

```bash
terraform plan
```

Resources created and managed by this configuration:

- IAM User & access key for Loggly
- S3 Bucket with CloudTrail policy
- Trail in CloudTrail
- SNS topic for CloudTrail

### Working with existing resources

By default the terraform plan will try to create new resources.

If you have existing resources, use:

```bash
terraform import aws_cloudtrail.main my-trial
terraform import aws_s3_bucket.main_trail my-trails-bucket
terraform import aws_sns_topic.main_trail arn:aws:sns:<region>:<account>:sns-topic

# sample output:
> aws_sns_topic.main_trail: Importing from ID "arn:aws:sns:<region>:<account>:sns-topic"...
> aws_sns_topic.main_trail: Import complete!
>   Imported aws_sns_topic (ID: arn:aws:sns:<region>:<account>:sns-topic)
> aws_sns_topic.main_trail: Refreshing state... (ID: arn:aws:sns:<region>:<account>:sns-topic)
> aws_cloudtrail.main: Import complete!
>   Imported aws_cloudtrail (ID: my-trail)
> aws_cloudtrail.main: Refreshing state... (ID: my-trail)
> aws_s3_bucket.main_trail: Importing from ID "my-trails-bucket"...
> aws_s3_bucket.main_trail: Import complete!
>   Imported aws_s3_bucket (ID: my-trails-bucket)
>   Imported aws_s3_bucket_policy (ID: my-trails-bucket)
> aws_s3_bucket.main_trail: Refreshing state... (ID: my-trails-bucket)
> aws_s3_bucket_policy.main_trail: Refreshing state... (ID: my-trails-bucket)
>
> Import success! The resources imported are shown above. These are
> now in your Terraform state. ...
> ...
```

**Note**: Pay close attention to the Terraform plan to ensure no unintended changes are applied to your existing `bucket`,  `bucket_policy` or `cloudtrail` settings.

### Applying changes

Once happy with the plan, apply the configuration changes:

```bash
terraform apply
```

Once completed, the end result may look as follows:

```
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:

Outputs:

loggly_aws_access_key_id = ...
loggly_aws_secret_access_key = ...
loggly_s3_bucket_name = ...
```

All values required for Loggly configuration are available as outputs of the configuration.

To print this information again:

```
terraform output
```
