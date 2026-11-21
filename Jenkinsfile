
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = 'divyanshuvvit/devopspro-website'

        AWS_ACCOUNT_ID = '742825129798'
        AWS_REGION = 'ap-southeast-2'

        ECR_REGISTRY = '742825129798.dkr.ecr.ap-southeast-2.amazonaws.com'
        ECR_REPOSITORY = 'devopspro-website'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Application') {
            steps {
                sh '''
                    test -f index.html
                    test -f css/style.css
                    test -f js/script.js
                    test -f Dockerfile

                    echo "Application validation successful."
                '''
            }
        }

        stage('Application Build') {
            steps {
                sh '''
                    mkdir -p build
                    cp index.html build/
                    cp -r css build/
                    cp -r js build/
                '''
            }
        }

        stage('Build Verification') {
            steps {
                sh '''
                    test -f build/index.html
                    test -f build/css/style.css
                    test -f build/js/script.js

                    echo "Build verification successful."
                '''
            }
        }

        stage('Docker Image Build') {
            steps {
                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                    -t ${IMAGE_NAME}:latest .

                    docker tag ${IMAGE_NAME}:${BUILD_NUMBER} \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}

                    docker tag ${IMAGE_NAME}:${BUILD_NUMBER} \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest
                '''
            }
        }

        stage('Docker Image Verification') {
            steps {
                sh '''
                    docker image inspect ${IMAGE_NAME}:${BUILD_NUMBER}

                    docker images ${IMAGE_NAME}

                    docker images ${ECR_REGISTRY}/${ECR_REPOSITORY}
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'c5427013-dbd0-403b-b001-67fcd8c46659',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        set +x

                        echo "$DOCKERHUB_TOKEN" | docker login \
                        -u "$DOCKERHUB_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'c5427013-dbd0-403b-b001-67fcd8c46659',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest

                        docker logout
                    '''
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    aws ecr get-login-password \
                    --region ${AWS_REGION} | \
                    docker login \
                    --username AWS \
                    --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Image to AWS ECR') {
            steps {
                sh '''
                    docker push \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}

                    docker push \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest

                    docker logout ${ECR_REGISTRY}
                '''
            }
        }
        
stage('Deploy to AWS EKS') {
    steps {
        withEnv(["KUBECONFIG=/var/lib/jenkins/.kube/config"]) {
            sh '''
                echo "Deploying DevOpsPro to Amazon EKS..."

                kubectl set image deployment/devopspro-website \
                  devopspro-website=742825129798.dkr.ecr.ap-southeast-2.amazonaws.com/devopspro-website:${BUILD_NUMBER}

                kubectl rollout status deployment/devopspro-website \
                  --timeout=300s

                echo "Verifying Kubernetes deployment..."

                kubectl get deployments
                kubectl get pods
                kubectl get services
            '''
        }
    }
}

        stage('Verify AWS ECR Images') {
            steps {
                sh '''
                    aws ecr describe-images \
                    --repository-name ${ECR_REPOSITORY} \
                    --region ${AWS_REGION}
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Docker images published to Docker Hub and AWS ECR!'
        }

        failure {
            echo 'Pipeline failed. Check Console Output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
