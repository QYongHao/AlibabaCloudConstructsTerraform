
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
  environment_variables = var.function_env_vars
  internet_access       = true
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

resource "alicloud_fcv3_custom_domain" "function" {
  count              = var.custom_domain_name != null ? 1 : 0
  custom_domain_name = var.custom_domain_name
  protocol           = "HTTP"
  route_config {
    routes {
      function_name = alicloud_fcv3_function.function.function_name
      qualifier     = "LATEST"
      path          = "/*"
      methods       = ["POST"]
    }
  }

  waf_config {
    enable_waf = false
  }

  auth_config {
    auth_type = "anonymous"
  }
}

locals {
  domain_parts = split(".", var.custom_domain_name)
  # Extract the last two parts for the root domain (e.g., "stevenssportinggoods.com")
  root_domain = join(".", slice(local.domain_parts, length(local.domain_parts) - 2, length(local.domain_parts)))
  # Extract all parts except the last two for the subdomain (e.g., "api")
  subdomain = join(".", slice(local.domain_parts, 0, length(local.domain_parts) - 2))
  # Generate the CNAME value in the required format
  fc_cname_value = "${var.alicloud_account_id}.${var.alicloud_region}-internal.fc.aliyuncs.com"
}

resource "alicloud_dns_record" "function" {
  count       = var.custom_domain_name != null ? 1 : 0
  name        = local.root_domain # e.g., "stevenssportinggoods.com"
  host_record = local.subdomain   # e.g., "api"
  type        = "CNAME"
  value       = local.fc_cname_value # e.g., "123456789.us-west-1-internal.fc.aliyuncs.com"
  ttl         = 600
}
