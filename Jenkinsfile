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
        sh """
            docker build -t Affaana/petclinic:${BUILD_NUMBER} .
            docker tag Affaana/petclinic:${BUILD_NUMBER} Affaana/petclinic:latest
        """
    }
}
stage('Push Docker Image') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )]) {

            sh '''
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                docker push affaana/petclinic:${BUILD_NUMBER}
                docker push affaana/petclinic:latest

                docker logout
            '''
        }
    }
}

        stage('Verify Docker Image') {
            steps {
                sh 'docker images'
            }
        }

        // stage('Deploy') {
          //   steps {
        //         sh './scripts/deploy.sh'
          //   }
        // }

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
