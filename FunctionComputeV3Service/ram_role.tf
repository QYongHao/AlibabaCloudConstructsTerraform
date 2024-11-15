resource "alicloud_ram_role" "default_ram_role" {
  count = var.function_role_arn == null ? 1 : 0
  name  = "${var.function_name}-role-${random_integer.default.result}"
  document = jsonencode({
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "fc.aliyuncs.com"
          ]
        }
      }
    ],
    "Version" : "1"
  })
  force = true
}

resource "alicloud_ram_role_policy_attachment" "function_log_full_access" {
  count       = var.function_role_arn == null ? 1 : 0
  role_name   = alicloud_ram_role.default_ram_role[0].name
  policy_name = "AliyunLogFullAccess"
  policy_type = "System"
}
