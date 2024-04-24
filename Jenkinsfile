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
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Ahmed-Elkoumy/DevOps-Project-2']])
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