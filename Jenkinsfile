pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "ahmeddevop/kitchensink"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ahmedalaa-devops/java-wildfly-project.git'
            }
        }
        stage('Build') {
            steps {
                dir('kitchensink') {
                    sh 'mvn clean package'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                dir('kitchensink') {
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }
        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
            }
        }
        stage('Deploy Container') {
            steps {
                sh '''
                docker rm -f kitchensink || true
                docker run -d -p 8081:8080 --name kitchensink $DOCKER_IMAGE:$DOCKER_TAG
                '''
            }
        }
        stage('Verify') {
            steps {
                sh 'sleep 10'
                sh 'curl -f http://localhost:8081/kitchensink'
            }
        }
    }
}
