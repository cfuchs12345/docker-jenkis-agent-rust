pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            dir 'build'
            label 'docker-slave'
            args '-v /tmp:/tmp'
        }
    }
    stages {
        stage('Build image') {
            steps {
                app = docker.build("christopherfuchs/jenkins-agent-rust")
            }
        }     
        stage('Test image') {      
            steps {
                app.inside {                         
                    sh 'echo "Tests passed"'        
                }    
            }
        }    
    }

    post{
        always{
            emailext body: 'Build executed',
            recipientProviders: [developers(), requestor()],
            subject: 'jenkins build ${JOB_DESCRIPTION}: ${BUILD_STATUS}',
            to: 'christopher@christopherfuchs.de'
        }
    }
}
