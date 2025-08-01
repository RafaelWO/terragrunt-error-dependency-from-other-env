variable "content_map" {
  type = map(object({
    from = list(string)
    txt  = string
  }))
  description = "File content map"
}

locals {
  mapped_output = { for key, value in var.content_map : key => length(value.from) > 0 ? "(${join(",", value.from)}) -> ${key}|${value.txt}" : "${key}|${value.txt}" }
}

output "content" {
  description = "Content"
  value       = join("\n", values(local.mapped_output))
}

output "content_map" {
  description = "Content map"
  value       = local.mapped_output
}
