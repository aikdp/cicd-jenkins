#!/bin/bash

USER_ID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILED"
        exit 1
    else
        echo "$2 is SUCCESS"
     fi
}

CHECK(){
    if [ $USER_ID -ne 0 ]
    then 
        echo "Please Run this scirpt with ROOT previleges"
        exit 1
    fi
}
CHECK

# Jenkins

sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo
#sudo dnf upgrade
# Add required dependencies for the Jenkins package
sudo dnf install fontconfig java-21-openjdk -y
sudo dnf install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
VALIDATE $? "Jenkins Installation"


# Install Docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl status docker
sudo usermod -aG docker ec2-user

VALIDATE $? "Docker user Installation"


echo "   =================================="
echo "** Your Jenkins Master server is ready for use **"
echo "   =================================="








