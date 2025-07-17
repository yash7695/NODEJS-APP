pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '120569645875.dkr.ecr.ap-south-1.amazonaws.com/noderepo'
        IMAGE_TAG = "v1-${BUILD_NUMBER}"
        AWS_ACCESS_KEY_ID = credentials('AKIARYEUCZMZ5QCJD67S')
        AWS_SECRET_ACCESS_KEY = credentials('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')
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
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region $AWS_REGION

                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker push $ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                      --cluster node-cluster \
                      --service node-service \
                      --force-new-deployment \
                      --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Successfully deployed Node.js app to ECS!'
        }
        failure {
            echo '❌ Build failed. Check logs!'
        }
    }
}
