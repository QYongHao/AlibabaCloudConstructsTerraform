output "ram_role_arn" {
  description = "The RAM role ARN that is assigned to the ${var.function_name} Function Compute service."
  value       = var.function_role_arn != null ? var.function_role_arn : alicloud_ram_role.default_ram_role[0].arn
}
