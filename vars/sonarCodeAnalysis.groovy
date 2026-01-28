def call(Map val = [:]){
  def sonarQubeAPI = val.sonarQubeAPI ?: 'Sonar'
  def projectname = val.projectname ?: 'easyshop'
  def projectKey = val.projectKey ?: 'easyshop'
  def sonarHome = val.sonarHome 
  
 withSonarQubeEnv("${sonarQubeAPI}"){
   sh "${sonarHome}/bin/sonar-scanner -Dsonar.projectName=${projectname} -Dsonar.projectKey=${projectKey} -X"
 }
}
