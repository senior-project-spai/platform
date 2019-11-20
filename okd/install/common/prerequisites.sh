#!/bin/bash
echo "Installing Prerequisites"

source ../settings.sh

cat >>/etc/hosts<<EOF
${OKD_MASTER_IP} ${OKD_MASTER_HOSTNAME} console console.${DOMAIN}
${OKD_WORKER_NODE_1_IP} ${OKD_WORKER_NODE_1_HOSTNAME}
${OKD_WORKER_NODE_2_IP} ${OKD_WORKER_NODE_2_HOSTNAME}
${OKD_WORKER_NODE_3_IP} ${OKD_WORKER_NODE_3_HOSTNAME}
${OKD_WORKER_NODE_4_IP} ${OKD_WORKER_NODE_4_HOSTNAME}
${OKD_WORKER_NODE_5_IP} ${OKD_WORKER_NODE_5_HOSTNAME}
EOF

# install the following base packages
yum update -y
yum install -y wget
yum install -y envsubst
yum install -y figlet
yum install -y git
yum install -y zile
yum install -y nano
yum install -y net-tools
yum install -y docker-1.13.1
yum install -y bind-utils iptables-services
yum install -y bridge-utils bash-completion
yum install -y kexec-tools
yum install -y sos
yum install -y psacct
yum install -y openssl-devel
yum install -y httpd-tools
yum install -y NetworkManager
yum install -y python-cryptography
yum install -y python2-pip
yum install -y python-devel
yum install -y python-passlib
yum install -y java-1.8.0-openjdk-headless "@Development Tools"
yum install -y epel-release
yum install -y yum-utils
