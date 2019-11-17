# checkout openshift-ansible repository
[ ! -d openshift-ansible ] && git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible 
git fetch 
git checkout release-3.11 
cd ~