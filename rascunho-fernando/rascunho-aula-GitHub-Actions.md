
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


git push --set-upstream origin teste-branch-1


fernando@debian10x64:~/cursos/terraform/github-actions-terraform-eks-traefik-app$ git push --set-upstream origin teste-branch-1

Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 464 bytes | 464.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
remote:
remote: Create a pull request for 'teste-branch-1' on GitHub by visiting:
remote:      https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app/pull/new/teste-branch-1
remote:
To github.com:fernandomullerjr/github-actions-terraform-eks-traefik-app.git
 * [new branch]      teste-branch-1 -> teste-branch-1
Branch 'teste-branch-1' set up to track remote branch 'teste-branch-1' from 'origin'.
fernando@debian10x64:~/cursos/terraform/github-actions-terraform-eks-traefik-app$
fernando@debian10x64:~/cursos/terraform/github-actions-terraform-eks-traefik-app$


 teste-branch-1 had recent pushes less than a minute ago 



- Actions
ativado Workflows
"There are no workflow runs yet."


- Gerado PR
https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app/pull/1

- PR não tem os "Checks" esperados:
    Workflow runs completed with no jobs







- Ajustando arquivo da pasta "eks", ajustado o outputs, apenas com a finalidade de triggar a pipeline.

~~~~bash
fernando@debian10x64:~/cursos/terraform/github-actions-terraform-eks-traefik-app$ git status
On branch teste-branch-1
Your branch is up to date with 'origin/teste-branch-1'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   eks/.infracost/terraform_modules/manifest.json
        modified:   eks/outputs.tf
        modified:   rascunho-fernando/rascunho-aula-GitHub-Actions.md

no changes added to commit (use "git add" and/or "git commit -a")
fernando@debian10x64:~/cursos/terraform/github-actions-terraform-eks-traefik-app$
~~~~


- Efetuando novo push:

git add .
git commit -m "CURSO devops --- AULA 58. GitHub Actions - Ajustado arquivo na pasta EKS, visando trigger da Pipeline e ocorrência de Checks no PR."
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push



- OK, funcionou, agora chamou os Checks do PR:

Terraform CI on: pull_request 7
Terraform
Terraform
failed Feb 11, 2023 in 9s
3s


- ERRO

~~~~bash
1s
2s
Run terraform init
  terraform init
  shell: /usr/bin/bash --noprofile --norc -e -o pipefail {0}
  env:
    TERRAFORM_CLI_PATH: /home/runner/work/_temp/dc224b8c-bfc0-4a26-9ed0-d4201a252ac5
    AWS_ACCESS_KEY_ID: ***
    AWS_SECRET_ACCESS_KEY: ***
/home/runner/work/_temp/dc224b8c-bfc0-4a26-9ed0-d4201a252ac5/terraform-bin init
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/eks/aws 19.7.0 for eks...
- eks in .terraform/modules/eks
- eks.eks_managed_node_group in .terraform/modules/eks/modules/eks-managed-node-group
- eks.eks_managed_node_group.user_data in .terraform/modules/eks/modules/_user_data
- eks.fargate_profile in .terraform/modules/eks/modules/fargate-profile
Downloading registry.terraform.io/terraform-aws-modules/kms/aws 1.1.0 for eks.kms...
- eks.kms in .terraform/modules/eks.kms
- eks.self_managed_node_group in .terraform/modules/eks/modules/self-managed-node-group
- eks.self_managed_node_group.user_data in .terraform/modules/eks/modules/_user_data
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 2.66.0 for vpc...
- vpc in .terraform/modules/vpc
╷
│ Error: Unsupported Terraform Core version
│ 
│   on versions.tf line 34, in terraform:
│   34:   required_version = "~> 0.14"
│ 
│ This configuration does not support Terraform version 1.3.8. To proceed,
│ either choose another supported Terraform version or update this version
│ constraint. Version constraints are normally set for good reason, so
│ updating the constraint may lead to other errors or unexpected behavior.
╵


Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
Error: Terraform exited with code 1.
Error: Process completed with exit code 1.
~~~~






- Ajustando arquivo de versões:
eks/versions.tf
DE:
required_version = "~> 0.14"
PARA:
required_version = "1.3.8"


- Efetuando novo push:

git add .
git commit -m "CURSO devops --- AULA 58. GitHub Actions - Ajustado version do Terraform."
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push



- NOVO ERRO
step do "Terraform Init"

~~~~bash
1s
1s
4s
Run terraform init
/home/runner/work/_temp/88fa721c-49f1-40f8-9693-de0ae11073a3/terraform-bin init
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/eks/aws 19.7.0 for eks...
- eks in .terraform/modules/eks
- eks.eks_managed_node_group in .terraform/modules/eks/modules/eks-managed-node-group
- eks.eks_managed_node_group.user_data in .terraform/modules/eks/modules/_user_data
- eks.fargate_profile in .terraform/modules/eks/modules/fargate-profile
Downloading registry.terraform.io/terraform-aws-modules/kms/aws 1.1.0 for eks.kms...
- eks.kms in .terraform/modules/eks.kms
- eks.self_managed_node_group in .terraform/modules/eks/modules/self-managed-node-group
- eks.self_managed_node_group.user_data in .terraform/modules/eks/modules/_user_data
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 2.66.0 for vpc...
- vpc in .terraform/modules/vpc

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Error refreshing state: AccessDenied: Access Denied
	status code: 403, request id: A8X4TFE71JSQ7QJS, host id: dHxJqdfqLARZyHKay+w6MW6eNnwJCp3MS6vqlOg/RwLN+YvMbCA1V+PJYyVccoU4VgIpM/+KKtI=

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
Error: Terraform exited with code 1.
Error: Process completed with exit code 1.
~~~~


- Erro de "AccessDenied"


# PENDENTE
- Erro de "AccessDenied"









# Dia 12/02/2023

All checks have failed
1 failing check
@github-actions
Terraform CI / Terraform (pull_request) Failing after 6s 



Error refreshing state: AccessDenied: Access Denied




- Ajustada a politica
arn:aws:iam::261106957109:policy/eks-politica-permite-terraform-github-actions
ADICIONADAS permissões de s3 e dynamodb

~~~~YAML
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*",
                "s3:*",
                "dynamodb:*",
                "ssm:*"
            ],
            "Resource": "*"
        }
    ]
}
~~~~


- Segue com erro:

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Error refreshing state: AccessDenied: Access Denied
	status code: 403, request id: Z4Y3P8Z3VV629JJN, host id: QKmME3Qa9kMT7b7LPAQ7sGiDTOFxi7oeVzBccso7GjDk7z9Rm8z37AfS4ke8WeOnIcYfX8a5sFk=


- Criado bucket no S3:
github-actions-terraform-eks-traefik-app-fernandomuller

- Ajustado manifesto do providers
eks/providers.tf