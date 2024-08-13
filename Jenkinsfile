pipeline {
    agent any
    
    tools{
        jdk 'openjdk8'
        maven 'maven3'
    }

    stages {
        stage('SCM') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/srini10112000/srinidhi.mr.git'
            }
        }
        stage('maven') {
            steps {
                sh "mvn clean install"
            }
        }
        stage('docker') {
            steps 
                script{
                    withDockerRegistry(credentialsId: '510dd16b-c6ef-4d84-a098-9c4f0390b6b6', toolName: 'docker8/7') {
                        sh "docker build -t srini10112000/docker2024:tagn1 ."
                        sh "docker push srini10112000/docker2024:tagn1"

                        
                    }
                }
            }
        }
    }
