pipeline {
    agent any

    environment {
        // Set environment variables if needed
        GITHUB_REPO = 'https://github.com/MdAbdullah5/Abdullah_infintudeIT.git'
        TERRAFORM_DIR = 'terraform'
        PYTHON_DIR = 'fastapi_app'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the source code from GitHub
                    git url: 'https://github.com/MdAbdullah5/Abdullah_infintudeIT.git' , branch: 'main'  // Change to your default branch if needed
                }
            }
        }

        stage('Static Code Analysis') {
            steps {
                script {
                    // Run static code analysis (e.g., with pylint or flake8)
                    sh "pip install pylint"  // Install pylint, modify if you use another tool
                    def analysis = sh(script: "pylint ${PYTHON_DIR}", returnStatus: true)

                    if (analysis != 0) {
                        error "Static code analysis failed. Please fix the issues."
                    }
                }
            }
        }

      stages {
        stage('Terraform Apply') {
            steps {
                script {
                    // Change directory to where the Terraform script is located
                    dir(TERRAFORM_DIR) {
                        sh 'terraform init'  // Initialize Terraform
                        sh 'terraform apply -auto-approve'  // Apply the Terraform script

                        // Capture the instance IP from Terraform output
                        instanceIp = sh(script: 'terraform output -json instance_ip', returnStdout: true).trim()
                        echo "Instance IP: ${instanceIp}"  // Print the instance IP
                    }
                }
            }
        }

        stage('Deploy FastAPI Application') {
            steps {
                script {
                    // SSH into the EC2 instance and run the FastAPI application
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${instanceIp} << 'EOF'
                    sudo yum install git
                    git clone https://github.com/MdAbdullah5/Abdullah_infintudeIT.git
                    cd  ./ Abdullah_infintudeIT # Navigate to the FastAPI app directory
                    # Create a virtual environment and install dependencies
                    #  python3 -m venv venv
                    #  source venv/bin/activate
                    sudo yum install python3-pip -y
                    sudo pip install fastapi uvicorn sqlite
                    uvicorn main:app --host 0.0.0.0 --port 8000 &
                    EOF
                    """
                }
            }
        }
        // stage('Configure Load Balancer') {
        //     steps {
        //         script {
        //             // Assuming you have AWS CLI installed and configured
        //             sh '''
        //             aws elbv2 create-load-balancer \
        //                 --name my-load-balancer \
        //                 --subnets <SUBNET_ID_1> <SUBNET_ID_2> \
        //                 --security-groups <SECURITY_GROUP_ID>

        //             aws elbv2 create-target-group \
        //                 --name my-target-group \
        //                 --protocol HTTP \
        //                 --port 80 \
        //                 --vpc-id <VPC_ID>

        //             aws elbv2 register-targets \
        //                 --target-group-arn <TARGET_GROUP_ARN> \
        //                 --targets Id=<EC2_INSTANCE_ID>

        //             aws elbv2 create-listener \
        //                 --load-balancer-arn <LOAD_BALANCER_ARN> \
        //                 --protocol HTTP \
        //                 --port 80 \
        //                 --default-actions Type=forward,TargetGroupArn=<TARGET_GROUP_ARN>
        //             '''
        //         }
        //     }
        // }
    }

    post {
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}
