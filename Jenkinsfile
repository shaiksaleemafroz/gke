pipeline {
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['Preproduction', 'Production', 'UAT'], description: 'Select the target environment')
    }
    agent any
    environment {
        PROJECT_ID = 'my-bigquery-project-434'
        CLUSTER_NAME = 'cluster-1'
        LOCATION = 'us-central1'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        GCP_CREDENTIALS_ID = 'gcp-service-account'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build image") {
            steps {
                script {
                    def myapp = docker.build("afroz2022/hello:${env.BUILD_ID}")
                    env.MYAPP_IMAGE = myapp.imageName()
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', env.DOCKER_CREDENTIALS_ID) {
                        def myapp = docker.image("afroz2022/hello:${env.BUILD_ID}")
                        myapp.push("latest")
                        myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: env.GCP_CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh """
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud container clusters get-credentials ${env.CLUSTER_NAME} --region ${env.LOCATION} --project ${env.PROJECT_ID}
                        sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml
                        kubectl apply -f deployment.yaml
                    """
                }
            }
        }
    }
}
