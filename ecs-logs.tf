
#logs
resource "aws_cloudwatch_log_group" "log_ecs" {
  name = "log_ecs"
  retention_in_days = 3
}


#IAM
resource "aws_iam_role" "projeto_task_execution_role" {
  name               = "projeto-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.projeto_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}
