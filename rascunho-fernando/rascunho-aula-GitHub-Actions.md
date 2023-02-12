
-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
## Git - commit - resumo

git add .
git commit -m "CURSO devops-mao-na-massa-docker-kubernetes-rancher --- AULA 58. GitHub Actions - Terraform + EKS"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push




-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
## AWS Keys

- ANTES:

trazendo buckets incorretos:

fernando@debian10x64:~$ aws s3 ls
2022-04-02 19:13:00 tfstate-816678621138



- Ajustadas as credentials da AWS na VM Debian.
ajustada para:
arn:aws:iam::261106957109:user/fernandomullerjr8596


- Testando minha chave AWS

fernando@debian10x64:~$ aws s3 ls
2022-09-07 12:26:39 fernandomullerjr.site
2022-09-07 12:26:29 fernandomullerjr.site-logs
2022-07-27 21:18:17 tfstate-261106957109
2022-09-07 12:26:54 www.fernandomullerjr.site
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ date
Sat 11 Feb 2023 10:09:49 PM -03
fernando@debian10x64:~$



buscou os buckets corretos agora!







-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
## 58. GitHub Actions - Terraform + EKS

- Usar o material do README do Jonathan:
/home/fernando/cursos/terraform/github-actions-terraform-eks-traefik-app/README.md

- Efetuado fork do repo

Link do repo forkado:
https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app
<https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app>

- Arquivo do Github Actions, com os steps:
  /home/fernando/cursos/terraform/github-actions-terraform-eks-traefik-app/.github/workflows/eks.yaml



## Roteiro

- Repositorio
  - AWS Access Keys
  - IAM Permission
- Github Actions - Pipeline
- EKS 


- Necessário garantir as permissões necessárias no usuário dono das AWS Keys, senão, o Github Actions não vai conseguir provisionar a infra do Cluster EKS.


# Permissões IAM

https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

https://docs.aws.amazon.com/eks/latest/userguide/security_iam_id-based-policy-examples.html#policy_example3

- Policy original:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi",
                "ssm:GetParameter",
                "eks:ListUpdates",
                "eks:ListFargateProfiles"
            ],
            "Resource": "*"
        }
    ]
}
```



- Criei uma versão personalizad, mais permissiva:


```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*",
                "ssm:*"
            ],
            "Resource": "*"
        }
    ]
}
```




- Criando policy no IAM:

eks-politica-permite-terraform-github-actions
Permite que o Github Actions crie a estrutura do EKS via Terraform
arn:aws:iam::261106957109:policy/eks-politica-permite-terraform-github-actions

- Atrelada ao grupo:
arn:aws:iam::261106957109:group/devops-admin



# Github

- Ajustar as settings do Repositório
ir em Secrets das Actions
https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app/settings/secrets/actions

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

cadastradas!





# Pipeline

- Agora vamos trabalhar com o arquivo do pipeline:
.github/workflows/eks.yaml

- Sempre que houver alteração na pasta "eks", ele vai triggar a pipeline, devido a linha:
eks/**


- Depois, nos steps
ele usa um Ubuntu, sobe um Terraform
Faz um Terraform Init usando as credenciais que cadastramos no repo

~~~~yaml
    # Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc.
    - name: Terraform Init
      id: init
      run: terraform init
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
~~~~





# Terraform

- Ajustando o manifesto do eks-cluster
eks/eks-cluster.tf
Colocando a familia "t3a.micro" no lugar das small e medium

DE:

~~~~h
  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}
~~~~


PARA:

~~~~h
  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3a.micro"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3a.micro"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}
~~~~










# Actions

Workflows aren’t being run on this forked repository

Because this repository contained workflow files when it was forked, we have disabled them from running on this fork. Make sure you understand the configured workflows and their expected usage before enabling Actions on this repository.




- Criada uma branch
teste-branch-1


git add .
git commit -m "CURSO devops-mao-na-massa-docker-kubernetes-rancher --- AULA 58. GitHub Actions - Terraform + EKS"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
