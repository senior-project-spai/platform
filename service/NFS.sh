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
echo "Adding /etc/exports settings"
echo "/mnt/nfsshare 192.168.0.0/16(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo exportfs -a

echo "Creating NFS Folder for Zookeeper"
sudo mkdir /mnt/nfsshare/zookeeper-1
sudo mkdir /mnt/nfsshare/zookeeper-2
sudo mkdir /mnt/nfsshare/zookeeper-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-1
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/zookeeper-3
sudo chmod 777 /mnt/nfsshare/zookeeper-1
sudo chmod 777 /mnt/nfsshare/zookeeper-2
sudo chmod 777 /mnt/nfsshare/zookeeper-3
oc create -f https://gist.githubusercontent.com/supakornbabe/4168e78abdd2f3cc77af19041b99dbcb/raw/dba2d74dbf022273fd17ffe171381ca5b8ebf93c/zookeeper-nfs.yaml

echo "Creating NFS Folder for hawkular"
sudo mkdir /mnt/nfsshare/hawkular
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/hawkular
sudo chmod 777 /mnt/nfsshare/hawkular
oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/1d437e3ff7e5ed59a7a2a9c468ab2973b94742f1/nfs-hawkular.yaml

echo "Creating NFS Folder for Kafka"
sudo mkdir /mnt/nfsshare/kafka-1
sudo mkdir /mnt/nfsshare/kafka-2
sudo mkdir /mnt/nfsshare/kafka-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/kafka-1
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/kafka-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/kafka-3
sudo chmod 777 /mnt/nfsshare/kafka-1
sudo chmod 777 /mnt/nfsshare/kafka-2
sudo chmod 777 /mnt/nfsshare/kafka-3
oc create -f https://gist.githubusercontent.com/supakornbabe/e34dfebf79b4b84f311d16ed178e4436/raw/e5c27ffc8b238366aca7567de547e005164761d8/kafka-nfs.yaml

echo "Creating NFS Folder for mariadb"
sudo mkdir /mnt/nfsshare/mariadb
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mariadb
sudo chmod 777 /mnt/nfsshare/mariadb
sudo mkdir /mnt/nfsshare/mariadb-2
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mariadb-2
sudo chmod 777 /mnt/nfsshare/mariadb-2
sudo mkdir /mnt/nfsshare/mariadb-3
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mariadb-3
sudo chmod 777 /mnt/nfsshare/mariadb-3
oc create -f https://gist.githubusercontent.com/supakornbabe/032dc2fe0b09443e3e5b8d2c9c69d0d3/raw/80f1b1ff962168522614e3affa7a56c0d6b2d083/nfs-mariadb.yaml

echo "Creating NFS Folder for minio on all server"
sudo mkdir /mnt/nfsshare/minio
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/minio
sudo chmod 777 /mnt/nfsshare/minio

oc create -f https://gist.githubusercontent.com/supakornbabe/7b5211e1a72705771df3f3a223395766/raw/ad5b409bbd6bf5f49318459bdc8a81242b58c625/minio-nfs.yaml

echo "Creating NFS Folder for grafana"
sudo mkdir /mnt/nfsshare/grafana
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/grafana
sudo chmod 777 /mnt/nfsshare/grafana

oc create -f https://gist.githubusercontent.com/supakornbabe/dbfcb74d03affc1ea80472710b964ddc/raw/23b3d0cb307332ebf9ceeb3d0f4f7a7e109d4257/grafana-nfs.yaml


echo "Creating NFS Folder for mysql"
sudo mkdir /mnt/nfsshare/mysql0
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mysql0
sudo chmod 777 /mnt/nfsshare/mysql0
sudo mkdir /mnt/nfsshare/mysql1
sudo chown nfsnobody:nfsnobody /mnt/nfsshare/mysql1
sudo chmod 777 /mnt/nfsshare/mysql1
oc create -f https://gist.githubusercontent.com/supakornbabe/e75f75c3c253fbd2e3596af079e651d3/raw/4a2aafc146235c79332505e612fe7833c59f4e4e/mysql-nfs.yaml
