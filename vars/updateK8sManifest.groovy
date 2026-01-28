def call(Map val = [:]){
  def gitUserName = val.gitUserName ?: 'leuvanikita'
  def gitEmail = val.gitEmail ?: 'leuvanikita@gmail.com'
  def gitCredentials = val.gitCredentials ?: 'GitHub'
  def dockerImage = val.dockerImage ?: error("Image name is required")
  // def dockerMigrationImage = val.dockerMigrationImage ?: error("Image name is required")
  def imageTag = val.imageTag ?: 'latest'
  def manifestsPath = val.manifestsPath ?: 'kubernetes'

  withCredentials([usernamePassword(
                 credentialsId: gitCredentials,
                 usernameVariable: 'GIT_USERNAME',
                 passwordVariable: 'GIT_PASSWORD' 
             )]){
                  // Configure Git
                 sh """
                    git config user.name "${gitUserName}"
                    git config user.email "${gitEmail}"
                 """
                  // Update deployment manifests with new image tags - using proper Linux sed syntax
                  sh """
                      # Update main application deployment - note the correct image name is niki0303/easyshop-app
                      sed -i "s|image: ${dockerImage}:.*|image: ${dockerImage}:${imageTag}|g" ${manifestsPath}/deployment.yml
            
                      # Ensure ingress is using the correct domain
                      if [ -f "${manifestsPath}/ingress.yml" ]; then
                          sed -i "s|host: .*|host: easyshop.freshfinds.site|g" ${manifestsPath}/ingress.yml
                      fi
                      
                      # Check for changes
                      if git diff --quiet; then
                          echo "No changes to commit"
                      else
                          # Commit and push changes
                          git add ${manifestsPath}/*.yml
                          git commit -m "Update image tags to ${imageTag} and ensure correct domain [ci skip]"
                
                          # Set up credentials for push
                          git remote set-url origin https://\${GIT_USERNAME}:\${GIT_PASSWORD}@github.com/leuvanikita/tws-e-commerce-app.git
                          git push origin HEAD:\${GIT_BRANCH}
                      fi
                  """ 
                       // # Update migration job if it exists
                      // if [ -f "${manifestsPath}/migration-job.yml" ]; then
                      //     sed -i "s|image: ${dockerMigrationImage}:.*|image: ${dockerMigrationImage}:${imageTag}|g" ${manifestsPath}/migration-job.yml
                      // fi

                      // # Update migration job if it exists
                      // if [ -f "${manifestsPath}/mongodb-statefulset.yml" ]; then
                      //     sed -i "s|image: ${dockerMigrationImage}:.*|image: ${dockerMigrationImage}:${imageTag}|g" ${manifestsPath}/mongodb-statefulset.yml
                      // fi
  }
}
