resource "aws_s3_bucket" "bucketdoprojeto" {
  bucket = "${var.storage_s3}-${random_id.bucket_suffix.hex}"

  tags = {
    Nome = "${var.project_name}"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 2
}