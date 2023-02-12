
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