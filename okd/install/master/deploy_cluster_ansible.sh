#!/bin/bash
echo "Running ansible-playbook with deploy_cluster.yml config"
ansible-playbook -i ~/inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/deploy_cluster.yml
