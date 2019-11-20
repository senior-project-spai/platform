#!/bin/bash

hostnamectl set-hostname master01.spai.ml

echo "Installing Prerequisites"

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


echo "Checking Network"
systemctl | grep "NetworkManager.*running"
if [ $? -eq 1 ]; then
        systemctl start NetworkManager
        systemctl enable NetworkManager
fi

echo "Enabling Docker"
systemctl restart docker
systemctl enable docker

echo "Adding master's public key to all server in cluster"
ssh-copy-id root@${OKD_MASTER_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_1_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_2_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_3_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_4_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_5_HOSTNAME}

# install the packages for Ansible
echo "install the packages for Ansible"
yum -y --enablerepo=epel install ansible pyOpenSSL
curl -o ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.5-1.el7.ans.noarch.rpm
yum -y --enablerepo=epel install ansible.rpm

# checkout openshift-ansible repository
echo "checking out openshift repo at branch release-${OKD_VERSION}"
[ ! -d openshift-ansible ] && git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible 
OPENSHIFT_ANSIBLE_REPO_PATH=$PWD
git fetch 
git checkout release-${OKD_VERSION}
cd ..

echo "Creating htpasswd file for storing username and password of okd"
mkdir -p /etc/origin/master/
touch /etc/origin/master/htpasswd

echo "Downloading inventory file to ~"
cd ~
wget https://raw.githubusercontent.com/senior-project-spai/platform/master/okd/inventory_template.ini
envsubst < inventory_template.ini > inventory.ini

echo "Running ansible-playbook with prerequisites.yml config"
ansible-playbook -i ~/inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/prerequisites.yml

echo "Running ansible-playbook with deploy_cluster.yml config"
ansible-playbook -i ~/inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/deploy_cluster.yml

echo "adding ${OKD_USERNAME} to okd with password ${OKD_PASSWORD}"
htpasswd -b /etc/origin/master/htpasswd ${OKD_USERNAME} ${OKD_PASSWORD}
oc adm policy add-cluster-role-to-user cluster-admin ${OKD_USERNAME}

echo "Deploying helm services"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod +x get_helm.sh
./get_helm.sh
kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade

echo "#####################################################################"
echo "* Your console is https://console.${DOMAIN}:${API_PORT}"
echo "* Your username is ${OKD_USERNAME} "
echo "* Your password is ${OKD_PASSWORD} "
echo "*"
echo "* Login using:"
echo "*"
echo "$ oc login -u ${OKD_USERNAME} -p ${OKD_PASSWORD} https://console.${DOMAIN}:${API_PORT}/"
echo "#####################################################################"

oc login -u ${OKD_USERNAME} -p ${OKD_PASSWORD} https://console.${DOMAIN}:${API_PORT}/

echo "Finish"
