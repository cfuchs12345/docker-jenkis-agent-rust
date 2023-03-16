pipeline {
   agent {label 'docker-slave'}

    parameters {
      string(
         name: "Branch_Name", 
         defaultValue: 'master', 
         description: '')

         string(
            name: "DOCKER_IMAGE_VERSION", 
            defaultValue: '23.0.1-git', 
            description: 'version of docker base image')
         string(
            name: "IMAGE_NAME", 
            defaultValue: 'docker-jenkins-agent-rust', 
            description: 'name of the image')
         string(
            name: 'JENKINS_USER', 
            defaultValue: 'jenkins', 
            description: '')
         string(
            name: 'JENKINS_PASSWORD', 
            defaultValue: 'jenkins', 
            description: '')
         string(
            name: 'SSH_PORT',
            defaultValue: '2222',
            description: 'ssh port when started for test in Jenkins - should not use standard port 22 since is will be in use by the host system'
         )
   
        booleanParam(
           name: "PushImage", 
           defaultValue: false)
    }


   // Stage Block
   stages {// stage blocks
      stage("Build docker images") {
         steps {
            script {
               echo "Bulding docker images"
               def buildArgs = """\
                --build-arg DOCKER_IMAGE_VERSION=${params.DOCKER_IMAGE_VERSION} \
                --build-arg JENKINS_USER=${params.JENKINS_USER} \
                --build-arg JENKINS_PASSWORD=${params.JENKINS_PASSWORD} \
                --build-arg SSH_PORT=${params.SSH_PORT} \
                -f Dockerfile \
                ."""
                docker.build(
                   "${params.IMAGE_NAME}:latest",
                   buildArgs)
            }
         }
      }
   }
    post{
        always{
            emailext body: 'Build executed',
            recipientProviders: [developers(), requestor()],
            subject: 'jenkins build ${JOB_NAME}: ${BUILD_STATUS}',
            to: 'christopher@christopherfuchs.de'
        }
    }
}
