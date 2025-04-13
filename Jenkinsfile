pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'      // Correct Maven version from Jenkins Global Tools
        jdk 'Java 17'            // Correct JDK version from Jenkins Global Tools
    }

    environment {
        SONARQUBE_SCANNER_HOME = tool 'SonarScanner' // Match this with what's configured
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/nityaomnathial/MyWebApp.git', branch: 'master'
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
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PAT')]) {
                    bat '''
                        docker logout
                        echo %DOCKER_PAT% | docker login -u %DOCKER_USER% --password-stdin
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t nityaom/mywebapp:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                bat 'docker push nityaom/mywebapp:latest'
            }
        }

        stage('Git Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    bat '''
                        git config --global user.email "nnathial@my.centennialcollege.ca"
                        git config --global user.name "nityaomnathial"
                        git remote set-url origin https://%GIT_USER%:%GIT_TOKEN%@github.com/nityaomnathial/MyWebApp.git
                        git add .
                        git commit -m "Automated update from Jenkins"
                        git push origin master
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline complete! High fives all around!'
        }
        failure {
            echo '🚨 Pipeline failed — we ride again!'
        }
    }
}
