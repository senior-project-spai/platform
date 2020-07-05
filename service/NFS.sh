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
mkdir /mnt/nfsshare/zookeeper-1
mkdir /mnt/nfsshare/zookeeper-2
mkdir /mnt/nfsshare/zookeeper-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-1
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-3
sudo chmod 777 /mnt/nfsshare/zookeeper-1
sudo chmod 777 /mnt/nfsshare/zookeeper-2
sudo chmod 777 /mnt/nfsshare/zookeeper-3

echo "Creating NFS Folder for hawkular"
mkdir /mnt/nfsshare/hawkular
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/hawkular
sudo chmod 777 /mnt/nfsshare/hawkular

oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/1d437e3ff7e5ed59a7a2a9c468ab2973b94742f1/nfs-zookeeper.yaml
oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/1d437e3ff7e5ed59a7a2a9c468ab2973b94742f1/nfs-hawkular.yaml

echo "Creating NFS Folder for Kafka"
mkdir /mnt/nfsshare/kafka-1
mkdir /mnt/nfsshare/kafka-2
mkdir /mnt/nfsshare/kafka-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/kafka-1
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/kafka-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/kafka-3
sudo chmod 777 /mnt/nfsshare/kafka-1
sudo chmod 777 /mnt/nfsshare/kafka-2
sudo chmod 777 /mnt/nfsshare/kafka-3
oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/ed04c4e5c551ef12f2ab49a372f5b3d5ea9af8b2/nfs-kafka.yaml

echo "Creating NFS Folder for mariadb"
mkdir /mnt/nfsshare/mariadb
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mariadb
sudo chmod 777 /mnt/nfsshare/mariadb
mkdir /mnt/nfsshare/mariadb-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mariadb-2
sudo chmod 777 /mnt/nfsshare/mariadb-2
mkdir /mnt/nfsshare/mariadb-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mariadb-3
sudo chmod 777 /mnt/nfsshare/mariadb-3
oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/80f1b1ff962168522614e3affa7a56c0d6b2d083/nfs-mariadb.yaml

echo "Creating NFS Folder for minio on all server"
mkdir /mnt/nfsshare/minio
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/minio
sudo chmod 777 /mnt/nfsshare/minio

oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/05329ed84bbcd1bf88920de5ab8bc08452134e4f/nfs-minio.yaml
