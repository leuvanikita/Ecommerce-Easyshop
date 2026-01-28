def call(){
     echo 'Cleaning up Docker images...'
     // sh 'docker rmi $(docker images -aq)'
     sh 'docker image prune -f'
}
