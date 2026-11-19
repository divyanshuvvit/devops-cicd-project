
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
                '''
            }
        }

        stage('Docker Image Verification') {
            steps {
                sh '''
                    docker image inspect ${IMAGE_NAME}:${BUILD_NUMBER}
                    docker images ${IMAGE_NAME}
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
    }

    post {
        success {
            echo 'CI pipeline and Docker Hub image publishing completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check Console Output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
