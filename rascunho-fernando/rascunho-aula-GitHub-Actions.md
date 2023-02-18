
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
## RESUMO - Manual do projeto

- Trigger são PR's e commits que tenham modificações em arquivos da pasta eks(manifestos do Terraform do Cluster EKS).
- AWS Keys, ajustar. Cadastrar nas Secrets do repo do Github.
- Criar bucket no S3 na mesma região que o projeto. Ajustar o manifesto de providers, colocando este bucket.
- Criar 1 Token no Github, para uso no "actions/github-script@0.9.0". 
- Habilitar permissões dos Actions nas settings do repositório. Marcar "Workflows have read and write permissions in the repository for all scopes."


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


- Ajustar a policy do usuário não resolveu.






- Criado bucket no S3:
github-actions-terraform-eks-traefik-app-fernandomuller

- Bucket foi criado na mesma região que estará o projeto.

- Ajustado manifesto do providers
eks/providers.tf


- Commitando:

git add .
git commit -m "AULA 58. GitHub Actions - Terraform + EKS. Ajustando o provider, criado um novo bucket no S3."
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push

- RESOLVIDO!
passou do step de "Terraform init"






- Novo erro:
step:
"Run actions/github-script@0.9.0"

~~~~bash
4s
0s
Run actions/github-script@0.9.0
Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
RequestError [HttpError]: Resource not accessible by integration
Error: Resource not accessible by integration
    at /home/runner/work/_actions/actions/github-script/0.9.0/dist/index.js:8705:23
    at processTicksAndRejections (internal/process/task_queues.js:97:5) {
  status: 403,
  headers: {
    'access-control-allow-origin': '*',
    'access-control-expose-headers': 'ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, X-GitHub-SSO, X-GitHub-Request-Id, Deprecation, Sunset',
    connection: 'close',
    'content-encoding': 'gzip',
    'content-security-policy': "default-src 'none'",
    'content-type': 'application/json; charset=utf-8',
    date: 'Sun, 12 Feb 2023 23:46:50 GMT',
    'referrer-policy': 'origin-when-cross-origin, strict-origin-when-cross-origin',
    server: 'GitHub.com',
    'strict-transport-security': 'max-age=31536000; includeSubdomains; preload',
    'transfer-encoding': 'chunked',
    vary: 'Accept-Encoding, Accept, X-Requested-With',
    'x-content-type-options': 'nosniff',
    'x-frame-options': 'deny',
    'x-github-api-version-selected': '2022-11-28',
    'x-github-media-type': 'github.v3',
    'x-github-request-id': 'A100:5A28:3E58C41:807C26B:63E97A6A',
    'x-ratelimit-limit': '1000',
    'x-ratelimit-remaining': '999',
    'x-ratelimit-reset': '1676249210',
    'x-ratelimit-resource': 'core',
    'x-ratelimit-used': '1',
    'x-xss-protection': '0'
  },
  request: {
    method: 'POST',
    url: 'https://api.github.com/repos/fernandomullerjr/github-actions-terraform-eks-traefik-app/issues/1/comments',
    headers: {
      accept: 'application/vnd.github.-preview+json',
      'user-agent': 'actions/github-script octokit.js/16.43.1 Node.js/12.22.7 (Linux 5.15; x64)',
      authorization: 'token [REDACTED]',
      'content-type': 'application/json; charset=utf-8'
    },
    body: '{"body":"#### Terraform Format and Style 🖌`success`\\n#### Terraform Initialization ⚙️`success`\\n#### Terraform Plan 📖`failure`\\n\\n<details><summary>Show Plan</summary>\\n\\n```terraform\\n```\\n\\n</details>\\n\\n*Pusher: @fernandomullerjr, Action: `pull_request`*"}',
    request: { hook: [Function: bound bound register], validate: [Object] }
  },
  documentation_url: 'https://docs.github.com/rest/reference/issues#create-an-issue-comment'
}
~~~~




- Erro
Error: Resource not accessible by integration


- TSHOOT
<https://dev.to/callmekatootie/debug-resource-not-accessible-by-integration-error-when-working-with-githubs-graphql-endpoint-5bim>
This error basically talks about a permission issue. When working with Github apps, you may not have set the necessary permission to access the resource you need. Hence the Resource not accessible by integration error.

- Exemplo deste site:

>So - how would one go about finding out which permission is needed in this case?

>The graphql documentation does not talk about this - weirdly, one first needs to instead go to their REST api documentation. In our case, since we are interested in the count of the collaborators on a repository, we would look for the REST api that fetches the collaborators for a repository. That would be the list repository collaborators endpoint:
>GET /repos/{owner}/{repo}/collaborators

>Now that we know the endpoint path, we then head over to the permissions required for Github Apps page and proceed to locate this endpoint (Do a Ctrl / Cmd + F in your browser and search for the endpoint you need).

>We find the above endpoint under the Collaborators permission list:

>Collaborators Permission List

>which, if you scroll up, falls under the Metadata permissions. Boom! There you go! Head over to your Github App and under Repository permissions, provide read-only access for the Metadata permissions:

>Github App Repository Permissions

>That should resolve your "Resource not accessible by integration" issue.





- No meu caso, é provável que seja o comment, conforme:

~~~~bash
    method: 'POST',
    url: 'https://api.github.com/repos/fernandomullerjr/github-actions-terraform-eks-traefik-app/issues/1/comments',
~~~~

- Documentação:
<https://docs.github.com/en/rest/overview/permissions-required-for-github-apps?apiVersion=2022-11-28>
exemplo:
POST /repos/{owner}/{repo}/comments/{comment_id}/reactions (write)

<https://docs.github.com/en/rest/reactions?apiVersion=2022-11-28#create-reaction-for-a-commit-comment>


https://docs.github.com/en/developers/apps


- Criado 1 Token no Github:
FernandoTesteTerraform





    - uses: actions/github-script@0.9.0
      if: github.event_name == 'pull_request'
      env:
        PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}










## Automatic token authentication

<https://docs.github.com/en/actions/security-guides/automatic-token-authentication>

In this article

    About the GITHUB_TOKEN secret
    Using the GITHUB_TOKEN in a workflow
    Permissions for the GITHUB_TOKEN

GitHub provides a token that you can use to authenticate on behalf of GitHub Actions.
About the GITHUB_TOKEN secret

At the start of each workflow run, GitHub automatically creates a unique GITHUB_TOKEN secret to use in your workflow. You can use the GITHUB_TOKEN to authenticate in a workflow run.

When you enable GitHub Actions, GitHub installs a GitHub App on your repository. The GITHUB_TOKEN secret is a GitHub App installation access token. You can use the installation access token to authenticate on behalf of the GitHub App installed on your repository. The token's permissions are limited to the repository that contains your workflow. For more information, see "Permissions for the GITHUB_TOKEN."

Before each job begins, GitHub fetches an installation access token for the job. The GITHUB_TOKEN expires when a job finishes or after a maximum of 24 hours.

The token is also available in the github.token context. For more information, see "Contexts."







- Não é necessário criar 1 Secret com o valor do Token, conforme a DOC acima.


- Check segue com erro:
Error: Resource not accessible by integration





https://stackoverflow.com/questions/70435286/resource-not-accessible-by-integration-on-github-post-repos-owner-repo-ac
configure permissions in Actions settings



Workflow permissions

Choose the default permissions granted to the GITHUB_TOKEN when running workflows in this repository. You can specify more granular permissions in the workflow using YAML. Learn more.
Workflows have read and write permissions in the repository for all scopes.
Workflows have read permissions in the repository for the contents and packages scopes only.




- Estava com:
Workflows have read permissions in the repository for the contents and packages scopes only.

- Ajustado para:
Workflows have read and write permissions in the repository for all scopes.

- Marcada opção que permite que as Actions criem e aprovem PR.






git add .
git commit -m "AULA 58. GitHub Actions - Terraform + EKS, Novo teste do Check, ajustadas as permissões dos Actions no repositório!"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push




- Verificando o PR e os Checks
existem erros no step do "Terraform Plan"
Error: Terraform exited with code 1.
Error: Process completed with exit code 1.


- Detalhado:

~~~~bash
0s
4s
Run terraform plan -no-color
/home/runner/work/_temp/cb4e874d-bebe-4e0f-b55f-711c6fb52170/terraform-bin plan -no-color

Error: Unsupported argument

  on eks-cluster.tf line 5, in module "eks":
   5:   subnets         = module.vpc.public_subnets

An argument named "subnets" is not expected here.

Error: Unsupported argument

  on eks-cluster.tf line 14, in module "eks":
  14:   workers_group_defaults = {

An argument named "workers_group_defaults" is not expected here.

Error: Unsupported argument

  on eks-cluster.tf line 18, in module "eks":
  18:   worker_groups = [

An argument named "worker_groups" is not expected here.

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
Error: Terraform exited with code 1.
Error: Process completed with exit code 1.
~~~~




-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
# PENDENTE
- Ver sobre versão do TERRAFORM nos providers, pode estar quebrando o projeto.
- Tratar erros no Terraform Plan
https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app/pull/1/checks
<https://github.com/fernandomullerjr/github-actions-terraform-eks-traefik-app/pull/1/checks>
- Fazer merge da branch "teste-branch-1" com a branch "main", para triggar o apply do Terraform.
- Video continua em:
16:19h
na criação do apply
- Ver sobre commits e histórico no Profile, na cobrinha.




teste3



# Dia 17
ver sobre versão do terraform nos providers





- Ajustando arquivo de versões:
eks/versions.tf
DE:
required_version = "~> 0.14"
PARA:
required_version = "1.3.8"




~~~~bash
Run terraform init
/home/runner/work/_temp/f15a73aa-cddd-4d60-b31d-54eb33ba489a/terraform-bin init
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/eks/aws 19.10.0 for eks...
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
│   34:   required_version = "1.1.5"
│ 
│ This configuration does not support Terraform version 1.3.9. To proceed,
│ either choose another supported Terraform version or update this version
│ constraint. Version constraints are normally set for good reason, so
│ updating the constraint may lead to other errors or unexpected behavior.
╵

~~~~






- Passei para:
required_version = "1.3.9"








- Agora o erro é:

~~~~bash
0s
3s
Run terraform apply -auto-approve
/home/runner/work/_temp/31716924-4680-46d3-adc8-dce7c80fac18/terraform-bin apply -auto-approve
╷
│ Error: Unsupported argument
│ 
│   on eks-cluster.tf line 5, in module "eks":
│    5:   subnets         = module.vpc.public_subnets
│ 
│ An argument named "subnets" is not expected here.
╵
╷
│ Error: Unsupported argument
│ 
│   on eks-cluster.tf line 14, in module "eks":
│   14:   workers_group_defaults = {
│ 
│ An argument named "workers_group_defaults" is not expected here.
╵
╷
│ Error: Unsupported argument
│ 
│   on eks-cluster.tf line 18, in module "eks":
│   18:   worker_groups = [
│ 
│ An argument named "worker_groups" is not expected here.
╵

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

Warning: The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
Error: Terraform exited with code 1.
Error: Process completed with exit code 1.
~~~~












~> 0.14



    # Install the latest version of Terraform CLI and configure the Terraform CLI configuration file with a Terraform Cloud user API token
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 0.14.0
