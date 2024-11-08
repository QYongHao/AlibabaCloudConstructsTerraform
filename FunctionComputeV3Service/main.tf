resource "random_integer" "default" {
  max = 99999
  min = 10000
}

resource "alicloud_oss_bucket" "function_deployment_bucket" {
  bucket = "fc-deployment-${lower(var.function_name)}-${random_integer.default.result}"
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = var.function_dir
  output_path = "${path.module}/function.zip"
}

resource "alicloud_oss_bucket_object" "function" {
  bucket = alicloud_oss_bucket.function_deployment_bucket.bucket
  key    = "${var.function_name}-${data.archive_file.source.output_md5}.zip"
  source = data.archive_file.source.output_path
}

