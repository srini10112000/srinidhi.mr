pipeline {
    agent any
    stages {
        stage ('RUN PARALLEL') {
            parallel {
                stage ('BUILD') {
                    steps {
                        echo "This is build stage"
                    }
                }
                stage ('Deploy') {
                    steps {
                        echo "This is deploy stage"
                    }
                }
            }
        }
        stage ('Test'){
                    steps {
                        echo "This is test stage"
                    }
                }
    }
}
