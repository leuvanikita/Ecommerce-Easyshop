def call(Map val = [:]){
  def imageName = val.imageName ?: error("Image name is required")
  def imageTag = val.imageTag ?: 'latest'
  def dockerfile = val.dockerfile ?: 'Dockerfile'
  def context = val.context ?: '.'

  echo "Building Docker image: ${imageName}:${imageTag} using ${dockerfile}"

  sh "docker build -t ${imageName}:${imageTag} -f ${dockerfile} ${context}"
}
