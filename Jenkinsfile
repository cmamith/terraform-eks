pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-southeast-1'
  }

  stages {
    stage('Terraform Init') {
      steps {
        dir('terraform/environments/dev') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('terraform/environments/dev') {
          sh 'terraform plan -var-file=terraform.tfvars'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        branch 'dev'
      }
      steps {
        dir('terraform/environments/dev') {
          sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh 'aws eks update-kubeconfig --region $AWS_REGION --name eks-dev'
        sh 'kubectl apply -f k8s/'
      }
    }
  }
}
