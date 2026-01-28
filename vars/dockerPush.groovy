def call(Map val = [:]){
  def dockerImage = val.dockerImage ?: error("App Image name is required")
  def dockerMigrationImage = val.dockerMigrationImage ?: error("Migration Image name is required")
  def dockerImageTag = val.dockerImageTag ?: 'latest'
  def credentials = val.credentials ?: 'DockerHub'
  def dockerMigrationTag = val.migrationImageTag ?: 'latest'
  echo "Pushing Docker image: ${dockerImage}:${dockerImageTag} and ${dockerMigrationImage}:${dockerImageTag}"

  withCredentials([usernamePassword(
    credentialsId: credentials,
    passwordVariable: "DockerHubPass",
    usernameVariable: "DockerHubUser"
  )]){
     sh """
          echo "${env.dockerHubPass}" | docker login -u "${env.dockerHubUser}" --password-stdin
          
          docker push ${dockerImage}:${dockerImageTag}
          docker push ${dockerMigrationImage}:${dockerMigrationTag}
     """
   }
}
