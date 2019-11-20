echo "${OKD_MASTER_IP} ${OKD_MASTER_HOSTNAME} console console.${DOMAIN}" | sudo tee -a /etc/hosts
echo "${OKD_WORKER_NODE_1_IP} ${OKD_WORKER_NODE_1_HOSTNAME}" | sudo tee -a /etc/hosts
echo "${OKD_WORKER_NODE_2_IP} ${OKD_WORKER_NODE_2_HOSTNAME}" | sudo tee -a /etc/hosts
echo "${OKD_WORKER_NODE_3_IP} ${OKD_WORKER_NODE_3_HOSTNAME}" | sudo tee -a /etc/hosts
echo "${OKD_WORKER_NODE_4_IP} ${OKD_WORKER_NODE_4_HOSTNAME}" | sudo tee -a /etc/hosts
echo "${OKD_WORKER_NODE_5_IP} ${OKD_WORKER_NODE_5_HOSTNAME}" | sudo tee -a /etc/hosts