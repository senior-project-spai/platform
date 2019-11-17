cd ~

../common/prerequisites.sh
../common/network_checker.sh
../common/enable_docker.sh

./install_ansible.sh
./clone_openshift_repo.sh
./create_htpaswd_file.sh
./get_inventory_file.sh
./install_prerequisite_ansible.sh
./deploy_cluster_ansible.sh
./add_user_to_openshift.sh
./deploy_helm_service.sh
