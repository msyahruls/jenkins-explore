pipeline{
  agent any

  environment {
    IMAGE_NAME = 'jenkins-demo'
    IMAGE_TAG = 'development'
    GCP_REPO = 'asia-southeast2-docker.pkg.dev/dgw-solution-dev/dgw'
    FULL_IMAGE = "${GCP_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
  }

  triggers {
    githubPush()
  }

  stages {
    stage('Check Branch') {
      when {
        not {
          branch 'development'
        }
      }
      steps {
        echo 'Not on development branch — skipping pipeline.'
        script {
          currentBuild.result = 'SUCCESS'
          return
        }
      }
    }

    stage('Build') {
      steps {
        sh 'go build -o app main.go'
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

    stage('Docker Build') {
      steps {
        sh 'docker build --platform linux/amd64 -t $FULL_IMAGE .'
      }
    }

    stage('Docker Push') {
      steps{
        withCredentials([file(credentialsId: 'd0db0491-b56d-44eb-b94d-4f1387454c6a', variable: 'GCP_KEY')]) {
          sh '''
            gcloud auth activate-service-account --key-file=$GCP_KEY
            gcloud auth configure-docker asia-southeast2-docker.pkg.dev --quiet
            docker push $FULL_IMAGE
          '''
        }
      }
    }
  }
}