#!/bin/bash
echo "Adding master's public key to all server in cluster"
ssh-copy-id root@${OKD_MASTER_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_1_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_2_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_3_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_4_HOSTNAME}
ssh-copy-id root@${OKD_WORKER_NODE_5_HOSTNAME}
