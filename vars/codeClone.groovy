def call(String url, String branch){
   git url: "${url}", branch: "${branch}"
   // sh "docker rmi -f \$(docker images -aq)"
}
