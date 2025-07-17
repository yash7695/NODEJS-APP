pipeline {
  agent any
 
  tools {
    nodejs 'Node-18'  
  }


  environment {
    AWS_REGION = "ap-south-1"
    IMAGE_NAME = "nodejs-app"
    ECR_URL = "120569645875.dkr.ecr.ap-south-1.amazonaws.com/noderepo"
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'npm test'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
        sh 'docker tag $IMAGE_NAME:latest $ECR_URL/$IMAGE_NAME:latest'
      }
    }

    stage('Push to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]) {
          sh '''
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
            docker push $ECR_URL/$IMAGE_NAME:latest
          '''
        }
      }
    }

    stage('Deploy to ECS') {
      steps {
        echo "🛠️ ECS deploy step (you can use Terraform or AWS CLI here)"
      }
    }
  }

  post {
    failure {
      echo "❌ Build failed. Check logs!"
    }
    success {
      echo "✅ Build and deploy completed successfully!"
    }
  }
}
