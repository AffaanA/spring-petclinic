pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

stage('Environment') {
            steps {
                sh 'whoami'
                sh 'echo JAVA_HOME=$JAVA_HOME'
                sh 'which java'
                sh 'java -version'
                sh './mvnw -version'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Spring PetClinic...'
                sh 'chmod +x mvnw'
                sh './mvnw clean package'
            }
        }

  stage('Deploy') {
            steps {
                sh './scripts/deploy.sh'
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully.'
        }

        failure {
            echo 'Build failed.'
        }
    }
}
