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

# install java
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
java -version
VALIDATE $? "Java 21 Installation"


# Install Java 8, Java 11 & Docker
apt update
apt install -y openjdk-8-jdk openjdk-11-jdk docker.io maven
usermod -a -G docker ubuntu
VALIDATE $? "Docker, java 8 and 11  Installation"

#Trivy
sudo apt-get install wget gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
VALIDATE $? "Trivy Installation"

echo "   =================================="
echo "** Your Jenkins Build server is ready for use **"
echo "   =================================="
