
resource "alicloud_fcv3_function" "function" {
  function_name = var.function_name
  description   = var.function_description != "" ? var.function_description : "${var.function_name} is created by Terraform"
  layers        = var.function_template_layer != "" ? var.function_template_layer : null
  timeout       = var.function_execution_timeout
  runtime       = var.function_runtime
  handler       = var.function_handler
  role          = var.function_role_arn != null ? var.function_role_arn : alicloud_ram_role.default_ram_role[0].arn
  disk_size     = var.function_disk_size
  cpu           = var.function_cpu
  memory_size   = var.function_memory_size
  log_config {
    enable_instance_metrics = true
    enable_request_metrics  = true
    logstore                = alicloud_log_store.function.logstore_name
    project                 = alicloud_log_project.function.project_name
  }
  code {
    oss_bucket_name = alicloud_oss_bucket.function_deployment_bucket.bucket
    oss_object_name = alicloud_oss_bucket_object.function.key
  }
  environment_variables = {
    WELL_KNOWN_ACME_CHALLENGE_BUCKET_NAME = "qtsc-sites-staging-650c2165-4a95-b3d1-f48a-b4e4cf7d3900"
  }
  internet_access = true
}

resource "alicloud_fcv3_trigger" "function" {
  trigger_type    = "http"
  trigger_name    = "${var.function_name}-function-http-trigger-${random_integer.default.result}"
  description     = var.function_description != "" ? var.function_description : "${var.function_name} is created by Terraform"
  qualifier       = "LATEST"
  function_name   = alicloud_fcv3_function.function.function_name
  invocation_role = var.function_role_arn != "" ? var.function_role_arn : alicloud_ram_role.default_ram_role[1].arn
  trigger_config = jsonencode({
    authType : "anonymous",
    disableURLInternet : false,
    methods : ["POST"]
  })
}
