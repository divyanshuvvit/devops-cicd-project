
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    triggers {
        githubPush()
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

                    echo "All required website files exist."
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
                echo 'Verifying build artifacts...'

                sh '''
                    test -f build/index.html
                    test -f build/css/style.css
                    test -f build/js/script.js

                    echo "Build verification successful."
                '''
            }
        }
    }

    post {
        success {
            echo 'CI Pipeline completed successfully!'
        }

        failure {
            echo 'CI Pipeline failed. Check console output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
