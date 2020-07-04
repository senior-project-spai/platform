#!/bin/bash
#The below configuration can be edited up on your needs and and please note the it's just an example configuration.
#We are going to create an OKD cluster with one master and 5 worker nodes.

#OKD Version
export OKD_VERSION=3.11

#OKD Master Node Configuration
export OKD_MASTER_IP=158.108.38.90
export OKD_MASTER_HOSTNAME=athena.local

#OKD Worker Node 1 Configuration
export OKD_WORKER_NODE_1_IP=158.108.38.88
export OKD_WORKER_NODE_1_HOSTNAME=a2.local

#OKD Worker Node 2 Configuration
export OKD_WORKER_NODE_2_IP=158.108.38.89
export OKD_WORKER_NODE_2_HOSTNAME=a1.local

#OKD Worker Node 3 Configuration
export OKD_WORKER_NODE_3_IP=158.108.38.91
export OKD_WORKER_NODE_3_HOSTNAME=a3.local

#OKD Worker Node 4 Configuration
export OKD_WORKER_NODE_4_IP=158.108.38.92
export OKD_WORKER_NODE_4_HOSTNAME=a4.local

#OKD Worker Node 5 Configuration
export OKD_WORKER_NODE_5_IP=158.108.38.93
export OKD_WORKER_NODE_5_HOSTNAME=a5.local

#The  below setting will be used to access OKD console https://console.$DOMAIN:$API_PORT"
#By default we can login using the URL https://console.spai.ml:8443
export DOMAIN=spai.ml
export API_PORT=8443

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
