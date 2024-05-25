
resource "aws_elasticache_cluster" "terraform_redis" {
  cluster_id           = "${var.redis_elasticashe}"
  engine            = "redis"
  node_type         = "cache.t2.micro"
  num_cache_nodes   = 1
  port              = 6379
  apply_immediately = true
}

