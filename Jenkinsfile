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
                sh 'docker --version'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Spring PetClinic...'
                sh 'chmod +x mvnw'
                sh './mvnw clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh """
			docker build -t petclinic:${BUILD_NUMBER} .
			docker tag petclinic:${BUILD_NUMBER} petclinic:latest

		"""
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker images'
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
