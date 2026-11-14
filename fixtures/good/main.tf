terraform {
  required_version = ">= 1.10.0"
}

variable "name" {
  description = "Nome de exemplo."
  type        = string
  default     = "world"
}

output "greeting" {
  description = "Saudação."
  value       = "hello ${var.name}"
}
