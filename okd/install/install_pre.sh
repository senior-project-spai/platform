#!/bin/bash

read -p "Enter Hostname: "  HOSTNAME

hostnamectl set-hostname ${HOSTNAME}

echo "Installing Prerequisites"
# install the following base packages
sudo yum update -y
sudo yum install -y wget
sudo yum install -y envsubst
sudo yum install -y figlet
sudo yum install -y git
sudo yum install -y zile
sudo yum install -y nano
sudo yum install -y net-tools
sudo yum install -y docker-1.13.1
sudo yum install -y bind-utils iptables-services
sudo yum install -y bridge-utils bash-completion
sudo yum install -y kexec-tools
sudo yum install -y sos
sudo yum install -y psacct
sudo yum install -y openssl-devel
sudo yum install -y httpd-tools
sudo yum install -y NetworkManager
sudo yum install -y python-cryptography
sudo yum install -y python2-pip
sudo yum install -y python-devel
sudo yum install -y python-passlib
sudo yum install -y java-1.8.0-openjdk-headless "@Development Tools"
sudo yum install -y epel-release
sudo yum install -y sudo yum-utils

echo "Checking Network"
systemctl | grep "NetworkManager.*running"
if [ $? -eq 1 ]; then
        systemctl start NetworkManager
        systemctl enable NetworkManager
fi

echo "Enabling Docker"
systemctl restart docker
systemctl enable docker

echo "Check /etc/hosts"
cat /etc/hosts

echo "Check hostname"
hostnamectl

echo "Check docker"
sudo docker ps

echo "Finish"
