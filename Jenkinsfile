pipeline {
    agent any
    tools
    {
        jdk 'jdk11'
        maven 'maven3'
    }
    environment
    {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: '5c9df7d6-fea5-4802-837d-3521aa82cf8b', url: 'https://github.com/chameerakularathna/Petclinic'
            }
        }
        stage('Compile Code') {
            steps {
                sh 'mvn clean compile'
            }
        }
       stage('Sonarqube Analysis') 
       {
            steps {
                sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.url=http://192.168.43.4:9000/ -Dsonar.login=squ_13f81064b900ea55b41bbf08860d509ea465acf6 -Dsonar.projectName=webshop \
                -Dsonar.java.binaries=. \
                -Dsonar.projectKey=webshop '''
            }
       }
         stage('OWASP Dependacy Scan') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependancy-check-report.xml'
            }
        }
         stage('Build Code') {
            steps {
                sh 'mvn clean install'
            }
        }
         stage('Build Docker Image') {
            steps {
              script
              {
                withDockerRegistry(credentialsId: 'bebe36e2-c4b9-45aa-9cf4-206394f82ccc', toolName: 'docker') {
                    sh " docker build -t charey/petclinic ."
                  }
              }
            }
        }
         stage('Deploy Docker Image') {
            steps {
              script
              {
                withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'dockerhubpwd')]) {
                 sh 'docker login -u chameeramadumalkularathna@gmail.com -p ${dockerhubpwd}'
                 sh 'docker push charey/petclinic '
                }
              }
            }
        }
        stage('Trigger CD Pipeline')
        {
            steps{
                build job: "cd-pipelin" , wait:true
            }
        }
    }
}
