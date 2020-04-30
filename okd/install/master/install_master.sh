#!/bin/bash

echo "checking out openshift repo at branch release-${OKD_VERSION}"
cd ${PLATFORM_REPO_FOLDER_LOCATION}/../..
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
cd ${PLATFORM_REPO_FOLDER_LOCATION}/../..
wget https://raw.githubusercontent.com/senior-project-spai/platform/master/okd/inventory_template.ini
envsubst < inventory_template.ini > inventory.ini

echo "Running ansible-playbook with prerequisites.yml config"
ansible-playbook -i ${PLATFORM_REPO_FOLDER_LOCATION}/../../inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/prerequisites.yml

echo "Running ansible-playbook with deploy_cluster.yml config"
ansible-playbook -i ${PLATFORM_REPO_FOLDER_LOCATION}/../../inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/deploy_cluster.yml

echo "Running ansible-playbook to enable hawkular matrics"
ansible-playbook -i ${PLATFORM_REPO_FOLDER_LOCATION}/../../inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/openshift-metrics/config.yml -e openshift_metrics_install_metrics=True -e openshift_metrics_hawkular_hostname=hawkular-metrics.apps.spai.ml -e openshift_metrics_cassandra_storage_type=pv -e openshift_metrics_cassandra_pvc_size=99Gi -e openshift_metrics_server_install=true

echo "adding ${OKD_USERNAME} to okd with password ${OKD_PASSWORD}"
htpasswd -b /etc/origin/master/htpasswd ${OKD_USERNAME} ${OKD_PASSWORD}
oc adm policy add-cluster-role-to-user cluster-admin ${OKD_USERNAME}

# echo "Deploying helm"
# curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
# chmod +x get_helm.sh
# ./get_helm.sh
# kubectl --namespace kube-system create serviceaccount tiller
# kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# helm init --service-account tiller --upgrade

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

echo "Deploying helm3"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm version

echo "Finish"
