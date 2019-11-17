#!/bin/bash

hostnamectl set-hostname master.spai.ml

../common/prerequisites.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/common/network_checker.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/common/enable_docker.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/add_publickey_to_all_nodes.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/install_ansible.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/clone_openshift_repo.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/create_htpaswd_file.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/get_inventory_file.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/install_prerequisite_ansible.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/deploy_cluster_ansible.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/add_user_to_openshift.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/master/deploy_helm_service.sh

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
