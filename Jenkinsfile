pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'
        jdk 'Java 17'
    }

    environment {
        SONARQUBE_SCANNER_HOME = tool 'SonarScanner'
        PATH = "${SONARQUBE_SCANNER_HOME}/bin:${env.PATH}"
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

        stage('SonarQube Analysis (Mocked)') {
            steps {
                echo '⚠️ SonarQube temporarily offline — mocking analysis step.'
                echo 'Pretending to run: mvn sonar:sonar'
            }
        }

        stage('Unit Tests') {
            steps {
                bat 'mvn test'
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
                        docker login -u %DOCKER_USER% -p %DOCKER_PAT%
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t nnathial/mywebapp:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                bat 'docker push nnathial/mywebapp:latest'
            }
        }

        stage('Git Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-pat', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
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
            echo '🚨 Pipeline failed — but you’re still a legend.'
        }
    }
}
