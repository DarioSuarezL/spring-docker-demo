pipeline {
    agent any
    tools {
        maven 'M3'  // Usa el mismo nombre que configuraste
    }    
    environment {
        //Define environment variables
        STAGING_SERVER = 'root@spring-docker-demo'
        ARTIFACT_NAME = 'demo-0.0.1-SNAPSHOT.jar'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/pablovillazon/spring-docker-maven2.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
	stage('Code Quality') {
	    steps {
		echo 'Skipping checkstyle for now'
		// sh 'mvn checkstyle:check'
	    }
	}
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Code Coverage') {
            steps {
                sh 'mvn jacoco:report'
            }
        }
	stage('Deploy to Staging') {
	    steps {
		sh '''
		    # Instalar sshpass si no está disponible
		    which sshpass || (apt-get update && apt-get install -y sshpass openssh-client)
		    
		    # Transferir archivo con sshpass
		    sshpass -p 'password123' scp -o StrictHostKeyChecking=no target/${ARTIFACT_NAME} ${STAGING_SERVER}:/var/local/staging/
		    
		    # Matar procesos Java anteriores y ejecutar nuevo
		    sshpass -p 'password123' ssh -o StrictHostKeyChecking=no ${STAGING_SERVER} "pkill -f 'java.*jar' || true"
		    sshpass -p 'password123' ssh -o StrictHostKeyChecking=no ${STAGING_SERVER} "nohup java -jar /var/local/staging/${ARTIFACT_NAME} > /var/local/staging/app.log 2>&1 &"
		'''
	    }
	}
        stage('Validate Deployment') {
            steps {
                sh 'sleep 10'
                sh 'curl --fail http://spring-docker-demo:8080/health'
            }
        }
    }
}
