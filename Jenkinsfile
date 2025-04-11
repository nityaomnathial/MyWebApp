pipeline {
    agent any
    tools {
        maven 'Maven 3.9.9'
    }
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        IMAGE_NAME = "nityaom/mywebapp"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nityaomnathial/MyWebApp.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MyLocalSonar') {
                    bat 'mvn sonar:sonar'
                }
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
            }
        }

        stage('Docker Login') {
            steps {
                bat "echo %DOCKER_HUB_CREDENTIALS_PSW% | docker login -u %DOCKER_HUB_CREDENTIALS_USR% --password-stdin"
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Docker Push') {
            steps {
                bat "docker push %IMAGE_NAME%"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
