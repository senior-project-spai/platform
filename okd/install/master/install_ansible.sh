#!/bin/bash
# install the packages for Ansible
echo "install the packages for Ansible"
yum -y --enablerepo=epel install ansible pyOpenSSL
curl -o ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.5-1.el7.ans.noarch.rpm
yum -y --enablerepo=epel install ansible.rpm