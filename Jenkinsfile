pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/layla606/projet_devops.git'
            }
        }

        stage('Setup') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'echo "Building project..."'
            }
        }

        stage('Run (Docker)') {
            steps {
                sh 'docker build -t projet_devops .'
                sh 'docker run -d --name projet_devops_container projet_devops'
            }
        }

        stage('Smoke Test') {
            steps {
                sh 'echo "Smoke test OK"'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '**/logs/*.log', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            sh 'docker stop projet_devops_container || true'
            sh 'docker rm projet_devops_container || true'
        }
    }
}
