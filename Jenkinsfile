pipeline {
    agent any
    
    environment {
        dockerHubRegistry = 'jinbaeco/demo_app'
        dockerHubRegistryCredential = credentials('dockerhub')
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven-3.6.0"
    }

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'master',url: 'https://github.com/jinbaeco/demo_app.git'
                //git credentialsId: 'github_ssh',
                //git url: 'https://github.com/jinbaeco/demo.git',
                //branch: 'master'

                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
                
            }
            
            post {
                failure {
                    echo 'Build failed!'
                }
                success {
                    echo 'Build successful!'
                }
            }
        }
        
        //dockerfile기반 빌드하는 stage ,git소스 root에 dockerfile이 있어야한다
        stage('Docker Image Build'){   
            steps {
            	//sh "cp target/demo_app-0.0.1-SNAPSHOT.jar ./"
                sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}"
                sh "docker build . -t ${dockerHubRegistry}:latest"
            }

            post {
                failure {
                echo 'Docker image build failure !'
                }
                success {
                echo 'Docker image build success !'
                }
            }
        }
        
        stage('Docker Login') {
        	steps{
        		sh "echo $dockerHubRegistryCredential_PSW | docker login -u $dockerHubRegistryCredential_USR --password-stdin"
        	}
        }
        
        stage('Docker Image Push') {
        	steps {
        		script {
        			sh "docker push ${dockerHubRegistry}:${currentBuild.number}"
        			sh "docker push ${dockerHubRegistry}:latest"
        		}
        	}
        	
        	post {
                    failure {
	                    echo 'Docker Image Push failure !'
	                    sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                   		sh "docker rmi ${dockerHubRegistry}:latest"
                    }
                    success {
	                    echo 'Docker image push success !'
	                    sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                   		sh "docker rmi ${dockerHubRegistry}:latest"
                    }
            }
        }
        
        stage('K8S Manifest Update') {
	        steps {
	            //git credentialsId: 'jenkins',
                git url: 'https://github.com/jinbaeco/demo_app.git',
                branch: 'master'
				   
				//sh "git config --global user.email 'jinbaeco@naver.com'"
				
	            sh "sed -i 's/demo_app:.*\$/demo_app:${currentBuild.number}/g' demo_deployment.yaml"
	            sh "git add demo_deployment.yaml"
	            sh "git commit -m '[UPDATE] demo_app ${currentBuild.number} image versioning'"
	            
	            sshagent(credentials: ['f60e188f-1463-4a29-87fa-38f8ec9442cb']) {
	                sh "git remote set-url origin https://github.com/jinbaeco/demo_app.git"
	                sh "git config --global user.name 'jinbaeco'"
	                sh "git config --global user.password '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'"
	                sh "git push origin master"			
                }
        	}    
		}
		
		
    }
}