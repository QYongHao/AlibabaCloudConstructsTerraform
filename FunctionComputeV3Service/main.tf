resource "random_integer" "default" {
  max = 99999
  min = 10000
}

resource "alicloud_oss_bucket" "function_deployment_bucket" {
  bucket                                   = "fc-deployment-${lower(var.function_name)}-${random_integer.default.result}"
  redundancy_type                          = "LRS"
  storage_class                            = "Standard"
  force_destroy                            = false
  lifecycle_rule_allow_same_action_overlap = false
  access_monitor {
    status = "Disabled"
  }
}

# Null resource to force re-evaluation
resource "null_resource" "refresh_trigger" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "npm run --prefix ${var.function_dir} build"
  }
}

# Archive file data resource
data "archive_file" "source" {
  type        = "zip"
  source_dir  = var.function_dir
  output_path = "${path.module}/function-${timestamp()}.zip"

  # Ensure this data source is re-evaluated when the null_resource changes
  depends_on = [null_resource.refresh_trigger]
}

resource "alicloud_oss_bucket_object" "function" {
  bucket = alicloud_oss_bucket.function_deployment_bucket.bucket
  key    = "${var.function_name}-${data.archive_file.source.output_md5}.zip"
  source = data.archive_file.source.output_path
}

