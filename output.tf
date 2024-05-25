output "nginx_dns" {
  value = aws_lb.ecs_nginx.dns_name
  description = "The DNS name for the nginx application load balancer"
}

output "rabbit_dns" {
  value = aws_lb.ecs_rabbit_con.dns_name
  description = "The DNS name for the rabbit application load balancer"
}

output "redis_dns" {
  value = aws_lb.ecs_redis_con.dns_name
  description = "The DNS name for the redis application load balancer"
}

output "minio_dns" {
  value = aws_lb.ecs_minio_con.dns_name
  description = "The DNS name for the minio application load balancer"
}