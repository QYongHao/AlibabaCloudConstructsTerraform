output "ram_role_arn" {
  description = "The RAM role ARN that is assigned to the Function Compute service."
  value       = var.function_role_arn != null ? var.function_role_arn : alicloud_ram_role.default_ram_role[0].arn
}

output "http_endpoint" {
  description = "The HTTP endpoint of the Function Compute service."
  value       = alicloud_fcv3_trigger.function.http_trigger[0].url_intranet
}
