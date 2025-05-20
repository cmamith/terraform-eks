pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-southeast-1'
  }

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Target environment')
  }

  stages {

    stage('Checkout') {
      steps {
        echo "🔄 Checking out code..."
        checkout scm
      }
    }

//     stage('YAML Lint') {
//   steps {
//     echo "🔍 Running yamllint using Docker"
//     sh '''
//      docker run --rm -v $(pwd):/data cytopia/yamllint /data
//     '''
//   }
// }

    stage('Terraform Init') {
      steps {
        script {
          def envPath = "environments/${params.ENVIRONMENT}"
          echo "🔧 Initializing Terraform for ${params.ENVIRONMENT} environment"
          dir(envPath) {
            sh 'pwd && ls -latr'
            sh "terraform init -reconfigure -backend-config=\"key=${params.ENVIRONMENT}/terraform.tfstate\""
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        script {
          def envPath = "environments/${params.ENVIRONMENT}"
          echo "📄 Terraform Plan for ${params.ENVIRONMENT}"
          dir(envPath) {
            sh "terraform plan -var-file=terraform.tfvars --lock=false"
          }
        }
      }
    }

    stage('Approval for Production') {
      when {
        expression { return params.ENVIRONMENT == 'prod' }
      }
      steps {
        input message: "🚨 Confirm Apply for Production?"
      }
    }

    stage('Terraform Apply') {
      steps {
        script {
          def envPath = "environments/${params.ENVIRONMENT}"
          echo "🚀 Applying Terraform changes to ${params.ENVIRONMENT}"
          dir(envPath) {
            sh "terraform apply -auto-approve -var-file=terraform.tfvars --lock=false"
          }
        }
      }
    }

    stage('Update Kubeconfig') {
      steps {
        echo "🔑 Updating kubeconfig for eks-${params.ENVIRONMENT}"
        sh "aws eks update-kubeconfig --region $AWS_REGION --name eks-${params.ENVIRONMENT}"
      }
    }

    stage('Deploy to EKS') {
      steps {
        echo "📦 Deploying application manifests to EKS cluster"
        sh 'kubectl apply -f K8s/'
      }
    }

  }

  post {
    success {
      echo "✅ Deployment to ${params.ENVIRONMENT} completed successfully."
    }
    failure {
      echo "❌ Deployment to ${params.ENVIRONMENT} failed. Check the logs."
    }
  }
}
