#!/bin/bash
echo "Running ansible-playbook with deploy_cluster.yml config"
ansible-playbook -i ~/inventory.ini openshift-ansible/playbooks/deploy_cluster.yml