pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-southeast-1'
  }

  stages {
    stage('Terraform Init') {
      steps {
        // Print current working directory and list files before running terraform init
        sh 'pwd'  // Print the current working directory
        sh 'ls -latr'  // List the contents of the current directory
        dir('terraform/environments/dev') {
          sh 'pwd'  // Print the current working directory inside the dev directory
          sh 'ls -latr' // List the contents of the current directory
          sh 'terraform init'  // Initialize Terraform
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('terraform/environments/dev') {
          sh 'pwd'  // Print the current working directory inside the dev directory
          sh 'terraform plan -var-file=terraform.tfvars'  // Plan the Terraform deployment
        }
      }
    }

    stage('Terraform Apply') {
      when {
        branch 'dev'
      }
      steps {
        dir('terraform/environments/dev') {
          sh 'pwd'  // Print the current working directory inside the dev directory
          sh 'terraform apply -auto-approve -var-file=terraform.tfvars'  // Apply Terraform changes
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh 'pwd'  // Print the current working directory
        sh 'aws eks update-kubeconfig --region $AWS_REGION --name eks-dev'  // Update kubeconfig for EKS
        sh 'kubectl apply -f k8s/'  // Deploy to EKS
      }
    }
  }
}
