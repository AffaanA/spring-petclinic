pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Spring PetClinic...'
                sh 'chmod +x mvnw'
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh './mvnw test'
            }
        }

	stage('Build Docker Image') {
	    steps {
		echo 'Building Docker Image. . . .'
		sh 'docker build -t affaana/petclinic:${BUILD_NUMBER} .'
	    }
	}
	stage('Tag Docker Image'){
	    steps {
		sh 'docker tag affaana/petclinic:${BUILD_NUMBER} affaana/petclinic:latest'
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
	stage('Deploy to Kubernetes') {
	   steps {
		echo 'Deploying to Kubernetes with Helm'
		sh '''
		export KUBECONFIG=/var/jenkins_home/.kube/config
		      helm upgrade --install petclinic ./helm/petclinic --set image.tag=${BUILD_NUMBER}
		'''
	   }
	}
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
