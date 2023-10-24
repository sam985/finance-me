pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID        = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY    = credentials('AWS_Secret_Key')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sam985/finance-me.git'
            }
        }
        stage('Build Package') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('HTML Reports') {
            steps {
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/finance-me/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t sam985/finance-me:1.0 .'
            }
        }
        stage('Docker Image Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker', passwordVariable: 'docker_login', usernameVariable: 'docker_user')]) {
                sh 'docker login -u ${docker_user} -p ${docker_login}'
                }
                sh 'docker push sam985/finance-me:1.0'
            }    
        }  
        stage('Configure Server with terraform and deploy using Ansible') {
           steps {
              dir('server-files') {
              sh 'sudo chmod 600 Gmail_keypair.pem'
              sh 'terraform init'
              sh 'terraform validate'
              sh 'terraform apply --auto-approve'
                   }   
                }
            }
        }
    }
