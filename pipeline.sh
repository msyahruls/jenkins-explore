pipeline{
  agent any
  triggers {
    githubPush()
  }
  stages {
    stage('Check Branch') {
      when {
        branch 'development'
      }

      steps {
        echo 'Not on development branch — skipping pipeline.'
        script {
          currentBuild.result = 'SUCCESS'
          return
        }
      }
    }

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