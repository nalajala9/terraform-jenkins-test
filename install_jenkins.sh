#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins 
wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar -xvf apache-maven-3.6.3-bin.tar.gz
sudo rm -rf /opt/*
sudo mv apache-maven-3.6.3 /opt/
echo "export M2_HOME=/opt/apache-maven-3.6.3" >> ~/.bashrc
echo "export PATH=$M2_HOME/bin:$PATH" >> ~/.bashrc
source ~/.bashrc






















