#!/bin/bash
#The below configuration can be edited up on your needs and and please note the it's just an example configuration.
#We are going to create an OKD cluster with one master and 5 worker nodes.

#OKD Version
export OKD_VERSION=3.11

#OKD Master Node Configuration
export OKD_MASTER_IP=192.168.0.101
export OKD_MASTER_HOSTNAME=athena

#OKD Worker Node 1 Configuration
export OKD_WORKER_NODE_1_IP=192.168.0.102
export OKD_WORKER_NODE_1_HOSTNAME=a2

#OKD Worker Node 2 Configuration
export OKD_WORKER_NODE_2_IP=192.168.0.103
export OKD_WORKER_NODE_2_HOSTNAME=a1

#OKD Worker Node 3 Configuration
export OKD_WORKER_NODE_3_IP=192.168.0.104
export OKD_WORKER_NODE_3_HOSTNAME=a3

#OKD Worker Node 4 Configuration
export OKD_WORKER_NODE_4_IP=192.168.0.105
export OKD_WORKER_NODE_4_HOSTNAME=a4

#OKD Worker Node 5 Configuration
export OKD_WORKER_NODE_5_IP=192.168.0.106
export OKD_WORKER_NODE_5_HOSTNAME=a5

#OKD Login Credentials
#By default admin/admin operator will be created and can be used to login to OKD console.
export OKD_USERNAME=admin
export OKD_PASSWORD=admin

#OKD Add-Ons
#Enable "True"  only if one of the VM has 4GB memory.
export INSTALL_METRICS=False

# Enable "True"  only one of the VM 16GB memory. 
export INSTALL_LOGGING=False

# Enter platform/okd repository location.
export PLATFORM_REPO_FOLDER_LOCATION=/home/hpcnc/platform/okd
