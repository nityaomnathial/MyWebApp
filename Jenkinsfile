pipeline {
    agent any
    tools {
        maven 'Maven 3.9.9' // MUST match the name from Global Tool Configuration
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
