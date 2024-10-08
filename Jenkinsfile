pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/MdAbdullah5/Abdullah_infintudeIT.git'
        TERRAFORM_DIR = './' // Directory to store Terraform files
        PYTHON_DIR = 'fastapi_app'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the source code from GitHub
                    git url: GITHUB_REPO, branch: 'main'  // Change to your default branch if needed
                }
            }
        }



        stage('Terraform Init and Apply') {
            steps {
                script {
                    // Change directory to where the Terraform file is located
                    dir(TERRAFORM_DIR) {
                        // Initialize Terraform
                        sh 'git clone https://github.com/MdAbdullah5/Abdullah_infintudeIT.git'
                        sh 'cd ./Abdullah_infintudeIT'
                        sh 'terraform init'
                        
                        // Apply the Terraform script and auto-approve
                        sh 'terraform apply -auto-approve'

                        // Capture the instance IP from Terraform output
                        def instanceIp = sh(script: 'terraform output -json instance_ip', returnStdout: true).trim()
                        echo "Instance IP: ${instanceIp}"  // Print the instance IP

                        // Store the instance IP for later stages
                        env.INSTANCE_IP = instanceIp
                    }
                }
            }
        }

        stage('Deploy FastAPI Application') {
            steps {
                script {
                    // SSH into the EC2 instance and run the FastAPI application
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${env.INSTANCE_IP} << 'EOF'
                    sudo yum install -y git
                    git clone ${GITHUB_REPO}
                    cd ./Abdullah_infintudeIT  # Navigate to the FastAPI app directory
                    sudo yum install python3-pip -y
                    sudo pip3 install fastapi uvicorn sqlite
                    nohup uvicorn main:app --host 0.0.0.0 --port 8000 &
                    EOF
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}
