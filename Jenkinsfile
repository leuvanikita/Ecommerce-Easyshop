@Library("Shared") _
pipeline{
    agent any
    
    environment{
        // DOCKER_USER_NAME = "niki0303"
        DOCKER_IMAGE_NAME = "niki0303/easyshop-app"
        DOCKER_MIGRATION_IMAGE_NAME = 'niki0303/easyshop-migration'
        DOKER_IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_USER_NAME = "niki0303"
        PROJ_NAME = "easyshop"
        SONAR_HOME = tool "Sonar"
    }
    
    stages{

        stage('Cleanup Workspace') {
            steps {
                script {
                    clean_ws()
                }
            }
        }
        
        stage("Code Clone"){
            steps{
                script{
                    codeClone("https://github.com/leuvanikita/tws-e-commerce-app.git", "devops")
                }
            }
        }
        
        stage("Sonar Code Analysis"){
            steps{
                script{
                    sonarCodeAnalysis(sonarQubeAPI: 'Sonar',
                                      projectname: env.PROJ_NAME,
                                      projectKey: env.PROJ_NAME,
                                      sonarHome: env.SONAR_HOME)
                }
            }
        }

        stage("Sonar Gate scan"){
            steps{
                script{
                    sonarQualityGate()
                }
            }
        }
        
         stage("OWASP Dependency check"){
            steps{
                script{
                    owaspDepencency("dc")
                }
            }
        }
        
        stage("Trivy scan"){
            steps{
                script{
                    trivyScan()
                }
            }
        }
        
        stage("Docker build"){
            parallel{
                stage("Docker app build"){
                    steps{
                        script{
                            build(imageName: env.DOCKER_IMAGE_NAME,
                                  imageTag: env.DOKER_IMAGE_TAG,
                                  dockerfile: 'Dockerfile',
                                  context: ".")
                        // sh "docker build -t ${env.DOCKER_IMAGE_NAME}:${env.DOKER_IMAGE_TAG} ."
                        }
                    }
                }
                stage("Docker migration build"){
                    steps{
                        script{
                            build(imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                  imageTag: 'latest',
                                  dockerfile: 'scripts/Dockerfile.migration',
                                  context: '.')
                        // sh "docker build -t ${env.DOCKER_MIGRATION_IMAGE_NAME}:${env.DOKER_IMAGE_TAG} -f 'scripts/Dockerfile.migration' ."
                        }
                    }
                }
            }
         }
         
         stage("Docker push"){
            steps{
                script{
                    dockerPush(dockerImage: env.DOCKER_IMAGE_NAME,
                               dockerMigrationImage: env.DOCKER_MIGRATION_IMAGE_NAME,
                               dockerImageTag: env.DOKER_IMAGE_TAG,
                               migrationImageTag: 'latest',
                               credentials: 'DockerHub')
                }
            }
         } 

         stage('Cleanup Docker Images') {
            steps {
                script{
                    cleanDockerImages()
                }
            }
         } 
          
          stage("Update Kubernetes Manifest"){
             steps{
                script{
                 updateK8sManifest(gitUserName: 'niki0303',
                                   gitEmail: 'leuvanikita@gmail.com',
                                   gitCredentials: 'GitHub',
                                   dockerImage: env.DOCKER_IMAGE_NAME,
                                   imageTag: env.DOKER_IMAGE_TAG,
                                   manifestsPath: 'kubernetes')
                    //             dockerMigrationImage: env.DOCKER_MIGRATION_IMAGE_NAME,
                }           
             }    
         }
    }
}
