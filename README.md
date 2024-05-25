# Projeto Ada - Modulo 4 - IAC
## Entrega
- workspace de dev e prd
- sqs, s3, elasticache foram incluidos
- minio, rabbitmq, redis foram incluidos no ecs e seus consoles são acessaveis pelos DNSs no output. Só é preciso acrescentar a porta:15672 - rabbitmq, :9001 - minio e :8001 - redis
**exemplo rabbitmq, substituir o DNS pelo gerado:**
```sh
infraAsCode-DES-rabbit-con-alb-329902006.us-east-1.elb.amazonaws.com:15672
```

## Para execução
Seguem a lista de ações:
### Alterar os valores das chaves
```sh
aws_access_key
aws_secret_key
```
Presentes em: 
 - dev.tfvars
 - prod.tfvars

### Comandos - Start do terraform na pasta
terraform workspace list
### Comandos - Montando no workspace de dev
```sh
terraform workspace new dev
>Pode ser pulado na 1º execução como o new já troca o workspace: terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
>Uma vez validado, use para remover: terraform destroy -var-file="dev.tfvars"
```

### Comandos - Montando no workspace de prod
```sh
terraform workspace new prod
>Pode ser pulado na 1º execução como o new já troca o workspace: terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
>Uma vez validado, use para remover: terraform destroy -var-file="prod.tfvars"
```
