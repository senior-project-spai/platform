#!/bin/bash
# checkout openshift-ansible repository
echo "checking out openshift repo at branch release-${OKD_VERSION}"
OPENSHIFT_ANSIBLE_REPO_PATH=$PWD
[ ! -d openshift-ansible ] && git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible 
git fetch 
git checkout release-${OKD_VERSION}
cd ..
