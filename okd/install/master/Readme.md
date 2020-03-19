## Install From Bare Server
```
sudo ssh-keygen

sudo yum install -y git

git clone https://github.com/senior-project-spai/platform

sudo chmod +x -R platform/okd/install

source platform/okd/install/settings.sh

platform/okd/install/add_hosts.sh

ssh-copy-id root@${OKD_MASTER_HOSTNAME}

ssh-copy-id root@${OKD_WORKER_NODE_1_HOSTNAME}

ssh-copy-id root@${OKD_WORKER_NODE_2_HOSTNAME}

ssh-copy-id root@${OKD_WORKER_NODE_3_HOSTNAME}

ssh-copy-id root@${OKD_WORKER_NODE_4_HOSTNAME}

ssh-copy-id root@${OKD_WORKER_NODE_5_HOSTNAME}

sudo platform/okd/install/install_pre.sh

sudo platform/okd/install/master/install_ansible.sh

platform/okd/install/master/install_master.sh

sudo platform/okd/install/master/install_post.sh
```