variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "The region for Azure resources"
}

variable "environment_short_name" {
  type = string
  validation {
    condition     = length(var.environment_short_name) == 3
    error_message = "The environment_short_name must be exactly 3 characters"
  }
}

variable "test1_prefix_name" {
  type        = string
  description = "Prefix name"
}

variable "test2_prefix_name" {
  type        = string
  description = "Prefix name"
}
