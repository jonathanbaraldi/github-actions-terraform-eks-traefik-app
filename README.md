# DevOps Ninja 

https://github.com/jonathanbaraldi/github-actions-terraform-eks-traefik-app.git


## Udemy
https://www.udemy.com/course/devops-mao-na-massa-docker-kubernetes-rancher/?referralCode=E0F907D36B02CEE83227

## Roteiro

- Repositorio
  - AWS Access Keys
  - IAM Permission
- Github Actions - Pipeline
- EKS 


1. Github Actions
  Criação de pipeline no Github Actions, com o Terraform+EKS.

2. Terraform
  Terraform irá provisionar cluster EKS.

3. EKS
  Cluster EKS será provisionar através do Terraform e do Github Actions

4. Traefik
  Instalação do Traefik para o cluster receber tráfego

5. Aplicação
  Fazer o deployment de aplicação via Github Actions + Terraform + Kubernetes



# Permissões IAM

https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

https://docs.aws.amazon.com/eks/latest/userguide/security_iam_id-based-policy-examples.html#policy_example3


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

# Conectar ao cluster

```sh

$ aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

```


https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html

Pegar o kubeconfig
```sh
$ aws sts get-caller-identity

$ aws eks --region us-east-2 update-kubeconfig --name <NOME_CLUSTER>

$ cat ~/.kube/config
```




# kubeconfig
```sh

apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ETXlNVEUzTXpNd01Wb1hEVE14TURNeE9URTNNek13TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT0VLCmNxdXY2bENxWnZLNE9GS0Q4endwMEE2S2dUaWdFYktDek5wTVA2NVdOUXV0eEpRUEs2cmpXWEtXZlBLNnRhcXAKVGxaanJzcXAyeU1XTjdiSjZ3WEc4bGtIOW5qenpLdzFBK2h1azBkb1Nvb3dWM2tUczBnV2J0bEhTZWVHT0dQbwppNWYzRzBoSUJadDl6QkJWSWM2SGZtbzQ3WmFWdTA3OHlRWGhPcExvMnJVeDh1M245NjRROEtsbHlXY1phUUpsCkEranFqaW5JT1p1MmNNZlZzT0lSQzJpbjhQZFhkTzJHcUJ6M3IvYktnTko3bjNLd0xnWjNVMFg3Szg5V0dDejUKc1YzM0Q0NE5OZzV1TG0yNTdkb2VOTE5IU3lQa09JZjdrZGIwQldscGpQWmp3dFIraTlFcmZqbFRXRk1rVkdoYgo1dkgyRUdpYUZNSmcrV0Z3UUtzQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFEbGFGaXhCQ2oyaTk0Z3VZT2RhT1RGRjRhVVQKR1k0OXE3eC8vL2JOTGx6aUpVdG8xbUFUN0FZQlkwNEJ3bjlCZGVjb2hTa3I2NEg3UnNNQmpCREZGbncyZUVSNQpjTkowQVRSY0lqN2x3dzJxaThRSzI3L3VnTUV5UDQvNk5aU29zWmFzYUtqblBseEZOQVFpY3Y3RG1hYzhFTUxXCkdoN2krU1FMVGdhdUVYR2lOUzJzU25tOXorMHNHRE9BeXJwdVF0UmN1ZFl5QkZ2NXNtZVFEMW1XVUhZNGRrNEgKV25tTE5sbXV6N2hEVVFJN05ic2tsK243MS8xYlBxOVlDWllwb0N0NHdyV1VtaFRDT3h0ckprc1g2ZDlyTmpWaApKUWZRbDJJTFYydEZwVklhKy8wUmN0azhZZnU4bUZtblJaNGNKejMwdndiM1BEeDN2OG0yZmdXUGJRcz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://0B29EF8DE893484EB8D0C75C4597DCE4.gr7.us-east-2.eks.amazonaws.com
  name: arn:aws:eks:us-east-2:984102645395:cluster/remessaonline-eks-iNwcOCRA
contexts:
- context:
    cluster: arn:aws:eks:us-east-2:984102645395:cluster/remessaonline-eks-iNwcOCRA
    user: arn:aws:eks:us-east-2:984102645395:cluster/remessaonline-eks-iNwcOCRA
  name: arn:aws:eks:us-east-2:984102645395:cluster/remessaonline-eks-iNwcOCRA
current-context: arn:aws:eks:us-east-2:984102645395:cluster/remessaonline-eks-iNwcOCRA
kind: Config
preferences: {}
users:
- name: arn:aws:eks:us-east-2:984102645395:cluster/remessaonline-eks-iNwcOCRA
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - us-east-2
      - eks
      - get-token
      - --cluster-name
      - remessaonline-eks-iNwcOCRA
      command: aws

# ===================================================

kubectl describe configmap -n kube-system aws-auth

```


https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes


apiVersion: v1
data:
  mapRoles: |
    - rolearn: arn:aws:iam::984102645395:role/education-eks-6kQEtLTZ2021031815122733450000000c
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::984102645395:user/serverless
      username: serverless
      groups:
        - system:masters
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"mapRoles":"- rolearn: arn:aws:iam::984102645395:role/education-eks-6kQEtLTZ2021031815122733450000000c\n  username: system:node:{{EC2PrivateDNSName}}\n  groups:\n    - system:bootstrappers\n    - system:nodes\n"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"aws-auth","namespace":"kube-system"}}
  creationTimestamp: "2021-03-19T17:15:44Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:mapRoles: {}
      f:metadata:
        f:annotations:
          .: {}
          f:kubectl.kubernetes.io/last-applied-configuration: {}
    manager: kubectl
    operation: Update
    time: "2021-03-19T17:15:44Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "18761"
  selfLink: /api/v1/namespaces/kube-system/configmaps/aws-auth
  uid: 93f39ad4-b400-492f-9767-cf9b5774776f




# TRAEFIK 1.7

O Traefik é a aplicação que iremos usar como ingress. Ele irá ficar escutando pelas entradas de DNS que o cluster deve responder. Ele possui um dashboard de  monitoramento e com um resumo de todas as entradas que estão no cluster.
```sh
$ kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml
$ kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-ds.yaml
$ kubectl --namespace=kube-system get pods
```
Agora iremos configurar o DNS pelo qual o Traefik irá responder. No arquivo ui.yml, localizar a url, e fazer a alteração. Após a alteração feita, iremos rodar o comando abaixo para aplicar o deployment no cluster.
```sh
$ kubectl apply -f traefik.yaml
```



# Atualizar Route 53 com is IP's dos worker's

13.59.206.139
18.218.161.24




```sh
# RANCHER SERVER
$ aws ec2 run-instances --image-id ami-0dba2cb6798deb6d8 --count 1 --instance-type t3.medium --key-name devops-ninja --security-group-ids sg-00c9550881117de86 --subnet-id subnet-09c5a4961e6056757 --user-data file://rancher.sh --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=rancherserver}]' 'ResourceType=volume,Tags=[{Key=Name,Value=rancherserver}]' 

```
