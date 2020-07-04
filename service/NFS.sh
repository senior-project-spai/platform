#!/bin/bash

echo "Creating NFS server"
sudo yum -y install firewalld
sudo systemctl start firewalld.service
sudo systemctl enable firewalld.service
sudo firewall-cmd --permanent --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --reload
sudo yum -y install nfs-utils
sudo systemctl enable nfs-server.service
sudo systemctl start nfs-server.service
sudo mkdir /mnt/nfsshare
sudo chown nfsnobody:nfsnobody /mnt/nfsshare
sudo chmod 777 /mnt/nfsshare
echo "Adding /etc/exports settings (Work only in KU Network)"
echo "/mnt/nfsshare 158.108.0.0/16(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo exportfs -a

echo "Creating NFS Folder for Zookeeper"
mkdir zookeeper-1
mkdir zookeeper-2
mkdir zookeeper-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-1
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-3
sudo chmod 777 /mnt/nfsshare/zookeeper-1
sudo chmod 777 /mnt/nfsshare/zookeeper-2
sudo chmod 777 /mnt/nfsshare/zookeeper-3

echo "Creating NFS Folder for hawkular"
mkdir hawkular
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/hawkular
sudo chmod 777 /mnt/nfsshare/hawkular

oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/1d437e3ff7e5ed59a7a2a9c468ab2973b94742f1/nfs-zookeeper.yaml
oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/1d437e3ff7e5ed59a7a2a9c468ab2973b94742f1/nfs-hawkular.yaml
