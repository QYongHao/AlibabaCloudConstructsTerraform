
resource "alicloud_log_project" "function" {
  project_name = "${lower(var.function_name)}-project-${random_integer.default.result}"
  description  = "Log project for ${var.function_name}"
}

resource "alicloud_log_store" "function" {
  project_name  = alicloud_log_project.function.project_name
  logstore_name = "${lower(var.function_name)}-store-${random_integer.default.result}"
  auto_split    = true
  append_meta   = true
}

resource "alicloud_log_store_index" "function" {
  project  = alicloud_log_project.function.project_name
  logstore = alicloud_log_store.function.logstore_name

  # Full-text search configuration for general log messages
  full_text {
    case_sensitive = false
    token          = " ,:{}\"\r\n\t"
  }

  # Index for specific fields (key-value search)
  field_search {
    name             = "functionName"
    enable_analytics = true
    type             = "text"
    token            = "-"
  }

  field_search {
    name             = "qualifier"
    enable_analytics = false
    type             = "text"
    token            = "-"
  }

  field_search {
    name             = "instanceID"
    enable_analytics = false
    type             = "text"
    token            = "-"
  }

  field_search {
    name             = "hasFunctionError"
    enable_analytics = true
    type             = "text"
    token            = "true,false"
  }

  field_search {
    name             = "ipAddress"
    enable_analytics = false
    type             = "text"
    token            = "."
  }

  field_search {
    name             = "memoryMB"
    enable_analytics = true
    type             = "double"
  }

  field_search {
    name             = "invokeFunctionLatencyMs"
    enable_analytics = true
    type             = "double"
  }

  field_search {
    name             = "invocationStartTimestamp"
    enable_analytics = false
    type             = "long"
  }

  field_search {
    name             = "isColdStart"
    enable_analytics = true
    type             = "text"
    token            = "true,false"
  }

  field_search {
    name             = "prepareCodeLatencyMs"
    enable_analytics = true
    type             = "double"
  }

  field_search {
    name             = "durationMs"
    enable_analytics = true
    type             = "double"
  }

  field_search {
    name             = "requestId"
    enable_analytics = false
    type             = "text"
    token            = "-"
  }

  field_search {
    name             = "operation"
    enable_analytics = true
    type             = "text"
    token            = "-"
  }

  field_search {
    name             = "memoryUsageMB"
    enable_analytics = true
    type             = "double"
  }
}
