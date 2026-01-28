def call(){
   sh "trivy fs --format table -o trivy-fs-report.html ."
}
