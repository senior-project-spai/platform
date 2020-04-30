#!/bin/bash
#The below configuration can be edited up on your needs and and please note the it's just an example configuration.
#We are going to create an OKD cluster with one master and 5 worker nodes.

#OKD Version
export OKD_VERSION=3.11

#OKD Master Node Configuration
export OKD_MASTER_IP=158.108.38.70
export OKD_MASTER_HOSTNAME=master01.spai.ml

#OKD Worker Node 1 Configuration
export OKD_WORKER_NODE_1_IP=158.108.38.71
export OKD_WORKER_NODE_1_HOSTNAME=node01.spai.ml

#OKD Worker Node 2 Configuration
export OKD_WORKER_NODE_2_IP=158.108.38.72
export OKD_WORKER_NODE_2_HOSTNAME=node02.spai.ml

#OKD Worker Node 3 Configuration
export OKD_WORKER_NODE_3_IP=158.108.38.73
export OKD_WORKER_NODE_3_HOSTNAME=node03.spai.ml

#OKD Worker Node 4 Configuration
export OKD_WORKER_NODE_4_IP=158.108.38.74
export OKD_WORKER_NODE_4_HOSTNAME=node04.spai.ml

#OKD Worker Node 5 Configuration
export OKD_WORKER_NODE_5_IP=158.108.38.75
export OKD_WORKER_NODE_5_HOSTNAME=node05.spai.ml

#The  below setting will be used to access OKD console https://console.$DOMAIN:$API_PORT"
#By default we can login using the URL https://console.spai.ml:8443
#To access URL from your local system we need to configure master host in C:\Windows\System32\drivers\etc\hosts file as below
#100.10.10.100  console.okd.nip.io
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
