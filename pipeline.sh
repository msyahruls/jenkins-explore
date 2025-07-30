pipeline{
  agent any
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/msyahruls/jenkins-explore.git'
      }
    }
    stage('Build') {
      steps {
        sh 'go build main.go'
      }
    }
    stage('Test') {
      steps {
        sh 'go test ./...'
      }
    }
    stage('Archive Binary') {
      steps {
        archiveArtifacts artifacts: 'app', fingerprint: true
      }
    }
  }
}