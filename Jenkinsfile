pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK-21'
    }

    environment {
        SONARQUBE_SCANNER_HOME = tool 'SonarQubeScanner'
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
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            bat '''
                docker logout
                echo Logging in with fresh PAT...
                echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
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
        failure {
            echo '🚨 Pipeline failed — we ride again!'
        }
        success {
            echo '✅ Pipeline complete! High fives all around!'
        }
    }
}
