pipeline {
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['Preproduction', 'Production', 'UAT'], description: 'Select the target environment')
    }
    agent any
    environment {
        PROJECT_ID = 'my-bigquery-project-434'
        CLUSTER_NAME = 'cluster-1'
        LOCATION = 'us-central1'
        CREDENTIALS_ID = 'docker-hub-credentials' // Defined once, used in both Docker and GKE deploy
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
                    myapp = docker.build("afroz2022/hello:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', env.CREDENTIALS_ID) {
                        myapp.push("latest")
                        myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
                step([
                    $class: 'KubernetesEngineBuilder',
                    projectId: env.PROJECT_ID,
                    clusterName: env.CLUSTER_NAME,
                    location: env.LOCATION,
                    manifestPattern: 'deployment.yaml',
                    credentialsId: env.CREDENTIALS_ID, // Using the same credentials ID here if it's a GCP service account
                    verifyDeployments: true
                ])
            }
        }
    }
}
