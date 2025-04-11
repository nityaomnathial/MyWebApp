pipeline {
    agent any
    tools {
        maven 'Maven 3.9.9'
    }
    environment {
        IMAGE_NAME = "nityaom/mywebapp"
        DOCKER_USERNAME = "nityaom"
        DOCKER_PASSWORD = "*bZM3Jy9t4?jyhF"
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
                bat '''
                echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                '''
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

        stage('Git Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-pat', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN')]) {
                    bat '''
                    git config --global user.name "%GIT_USERNAME%"
                    git config --global user.email "nnathial@my.centennialcollege.ca"
                    git remote set-url origin https://%GIT_USERNAME%:%GIT_TOKEN%@github.com/nityaomnathial/MyWebApp.git
                    git add .
                    git commit -m "Automated commit from Jenkins"
                    git push origin master
                    '''
                }
            }
        }
    }
}
