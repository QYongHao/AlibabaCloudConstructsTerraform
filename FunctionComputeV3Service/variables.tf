variable "function_name" {
  description = "Name of function"
}

variable "function_handler" {
  description = "Function handler"
  default     = "index.handler"
}

variable "function_dir" {
  description = "Path to the directory containing the function code"
  nullable    = false
}

variable "function_role_arn" {
  description = "ARN of the role to use for the function"
  nullable    = true
  default     = null
}

variable "function_description" {
  description = "Description of function"
  nullable    = true
  default     = null
}

variable "function_runtime" {
  description = "Runtime version used for the function instance"
  default     = "nodejs20"
}

variable "function_execution_timeout" {
  description = "Timeout period for execution of function"
  default     = 60
}

variable "function_disk_size" {
  description = "Disk size for function"
  default     = 512
}

variable "function_cpu" {
  description = "CPU used for function"
  default     = 0.1
}
variable "function_memory_size" {
  description = "Memory size for function"
  default     = 256
}

variable "function_template_layer" {
  description = "Template layer ARNs"
  type        = list(string)
  nullable    = true
  default     = null
}

variable "function_env_vars" {
  description = "Environment variables to be set for the function"
  type        = map(string)
  nullable    = true
  default     = null
}

variable "custom_domain_name" {
  description = "Custom domain name for HTTP function"
  type = string
  nullable = true
  default = null
}
