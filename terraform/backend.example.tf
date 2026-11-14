# Example only. Uncomment and configure after creating the S3 bucket.
# Do not put credentials in this file.
#
# terraform {
#   backend "s3" {
#     bucket       = "REPLACE_WITH_YOUR_UNIQUE_STATE_BUCKET"
#     key          = "ha-webapp/terraform.tfstate"
#     region       = "us-east-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
#
# Initialize/migrate state only after understanding the backend migration prompts.
