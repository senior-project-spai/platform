#!/bin/bash
echo "Running ansible-playbook with prerequisites.yml config"
ansible-playbook -i ~/inventory.ini ${OPENSHIFT_ANSIBLE_REPO_PATH}/playbooks/prerequisites.yml
