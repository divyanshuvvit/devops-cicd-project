
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
        IMAGE_NAME = 'devopspro-website'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Validate Application') {
            steps {
                echo 'Validating website files...'
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
                echo 'Preparing application...'
                sh '''
                    mkdir -p build
                    cp index.html build/
                    cp -r css build/
                    cp -r js build/
                    echo "Application build completed."
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
                    docker image inspect \
                    ${IMAGE_NAME}:${BUILD_NUMBER}

                    docker images ${IMAGE_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo 'CI and Docker image build completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check console output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
