variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project to create resources for"
  default     = "infraAsCode"
}

variable "service_rabbitmq" {
  description = "RabbitMQ service"
  default     = "rabbitmq-on-ecs"
}

variable "service_redis" {
  description = "Redis service"
  default     = "redis-on-ecs"
}

variable "service_minio" {
  description = "Minio service"
  default     = "minio-on-ecs"
}

variable "service_nginx" {
  description = "Nginx service"
  default     = "nginx-on-ecs"
}

variable "storage_s3" {
  description = "Storage"
  default     = "iac-s3"
}

variable "fila_sqs" {
  description = "Storage"
  default     = "iac-sqs"
}

variable "redis_elasticashe" {
  description = "Cache"
  default     = "iac-elasticashe"
}

variable "aws_access_key" {
  description = "Access Key ID da AWS"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret Access Key da AWS"
  type        = string
}

