
# install the following base packages
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


systemctl | grep "NetworkManager.*running"
if [ $? -eq 1 ]; then
        systemctl start NetworkManager
        systemctl enable NetworkManager
fi

systemctl restart docker
systemctl enable docker

# install oc CLI tool
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
mkdir -p /home/babe/bin
mv /home/babe/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz /home/babe/bin/
cd /home/babe/bin/
tar -xf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz


# install the packages for Ansible
yum -y --enablerepo=epel install ansible pyOpenSSL
curl -o ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.5-1.el7.ans.noarch.rpm
yum -y --enablerepo=epel install ansible.rpm

# checkout openshift-ansible repository
[ ! -d openshift-ansible ] && git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible && git fetch && git checkout release-3.11 && cd ..

mkdir -p /etc/origin/master/
touch /etc/origin/master/htpasswd

ansible-playbook -i inventory.ini openshift-ansible/playbooks/prerequisites.yml
ansible-playbook -i inventory.ini openshift-ansible/playbooks/deploy_cluster.yml

htpasswd -b /etc/origin/master/htpasswd babe 1q2w3e4r
oc adm policy add-cluster-role-to-user cluster-admin babe


curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod +x get_helm.sh
./get_helm.sh


kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade
