#!/bin/bash
echo "Running ansible-playbook with prerequisites.yml config"
ansible-playbook -i ~/inventory.ini openshift-ansible/playbooks/prerequisites.yml