pipeline {
    agent any
    tools {
        maven '3.9.9' // This must exactly match the Maven name in Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nityaomnathial/MyWebApp.git'
            }
        }
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }
        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
            }
        }
    }
}
