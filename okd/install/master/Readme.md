From Bare Server

sudo ssh-keygen

sudo yum install -y git

git clone https://github.com/senior-project-spai/platform

cd platform/okd

sudo chmod +x -R install

cd install

source settings.sh

cd ~/platform/okd/install/master

./add_hosts.sh

ssh-copy-id root@${OKD_MASTER_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_1_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_2_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_3_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_4_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_5_HOSTNAME}

sudo ./install_master.sh