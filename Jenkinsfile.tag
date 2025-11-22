pipeline {
    agent any

    // Default GIT_TAG if not running on a tag
    environment {
        GIT_TAG = "${env.GIT_TAG ?: 'dev-latest'}"
    }

    // Trigger on all commits, you can filter tags if needed
    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
            }
        }

        stage('Version Tag Check') {
            when {
                expression { return env.GIT_TAG != 'dev-latest' }
            }
            steps {
                echo "Running pipeline for version tag: ${env.GIT_TAG}"
            }
        }

        stage('Setup') {
            steps {
                echo "Setting up environment..."
                bat 'echo Windows environment ready'
            }
        }

        stage('Build') {
            steps {
                echo "Building project..."
                bat 'echo Simulate build process'
            }
        }

        stage('Run Docker') {
            steps {
                echo "Building & running Docker image..."
                bat "docker build -t myapp:${env.GIT_TAG} ."
                bat "docker run --name myapp_container -d myapp:${env.GIT_TAG}"
            }
        }

        stage('Smoke Test') {
            steps {
                echo "Running smoke tests..."
                bat '''
                REM Simulate smoke test
                echo Running smoke test...
                REM exit /b 0 => Passed, exit /b 1 => Failed
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "Archiving artifacts..."
                archiveArtifacts artifacts: '**/target/*.jar, **/logs/*.log', allowEmptyArchive: true
            }
        }

        stage('Cleanup') {
            steps {
                echo "Cleaning up..."
                bat 'docker stop myapp_container || echo Container not running'
                bat 'docker rm myapp_container || echo Container not removed'
            }
        }
    }

    post {
        always {
            echo "Pipeline finished (Passed/Failed logged above)"
        }
    }
}
