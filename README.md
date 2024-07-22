# DevOps-Project-2
**EKS with Terraform CI Jenkins
Deploy the application in AWS EKS using Terraform as IaC and continuously integrate new changes with Jenkins installed in EC2**

This project involves utilizing Terraform to provision essential resources such as a Virtual Private Cloud (VPC), Security Groups (SG), and Elastic Compute Cloud (EC2) instances. 
Additionally, Jenkins is deployed in that EC2 to automate the process. 
Jenkins, triggered by a GitHub webhook, retrieves another Terraform code to dynamically provision the infrastructure for Amazon Elastic Kubernetes Service (EKS).
Furthermore, the configuration of an Nginx server within the EKS cluster is implemented as part of this project

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/30b839d0-7e77-4081-88fb-bf5d9e66b223)

**Installing Terraform in Codespace
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli**


Configure AWS CLI
Create access keys

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/6e340816-32cc-49d5-b00b-0e2b796e257c)

 Install and Configure AWS CLI

 #in terminal
 sudo apt install awscli -y
 aws configure
 #enter your access key ID and secret, and default region

 **Create S3 bucket for Terraform backend**

 ![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/be8a0ccd-a6e9-4789-842c-900e53b8df4a)

creating vpc, SG and EC2 for jenkins

 terraform init
 terraform plan
 terraform validate
 terraform apply

Push all code to GitHub repo

Resources created:
VPC
![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/25c89dba-9cce-477a-88b9-d1539911c767)

Subnets
![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/8388b9fc-0a87-4ba8-b244-da6230f79ce5)

InternetGateways
![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/a80763ef-c245-4440-a527-6dc015a02d66)

 Security Groups
![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/d51ee6e2-f279-45a0-9fa5-54faca6d8b60)



**Creating pipeline**

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/71811a8e-03d1-42bb-8d42-0d58843df5a4)


 Use GitHub webhook and configure pipeline to pull Jenkinsfile from GitHub repo.

pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ca-central-1"
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Rupak-Shrestha/EKS-with-Terraform-CI-Jenkins.git']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Planning Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Creating EKS Cluster'){
            steps{
                script{
                    dir('eks') {
                        sh 'terraform destroy --auto-approve'
                    }
                }
            }
        }
        stage('Deploying Application') {
            steps{
                script{
                    dir('config-files/') {
                        sh 'aws eks update-kubeconfig --name eks-cluster'
                        sh 'kubectl apply -f deployment.yml'
                        sh 'kubectl apply -f service.yml'
                    }
                }
            }
        }
    }
}


![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/acd51f53-26a4-4ca4-9afb-09093a260004)

**Cluster created**

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/5929c344-8df4-465f-83ab-93d0ac7a4ba0)

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/ec9dcdac-18f2-4c81-a2d5-5e6e8e15a2e1)

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/0ee2ddde-3b7a-4953-8745-3b215eb83d91)

**Access nginx with the load balancer URL**

![image](https://github.com/Ahmed-Elkoumy/DevOps-Project-2/assets/163794226/370ec70c-8404-4d52-8194-9d472b9354ea)

