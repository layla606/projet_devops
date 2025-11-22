pipeline {
    agent any

    // Trigger on version tags only
    triggers {
        // Optional: Poll SCM if you can't use webhook
        pollSCM('H/5 * * * *')
    }

    // Only run on version tags vX.Y.Z
    when {
        tag "v*.*.*"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
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
                // For example: bat 'mvn clean package' for Java, or 'npm install && npm run build'
            }
        }

        stage('Run Docker') {
            steps {
                echo "Building & running Docker image..."
                bat 'docker build -t myapp:${GIT_TAG} .'
                bat 'docker run --name myapp_container -d myapp:${GIT_TAG}'
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
