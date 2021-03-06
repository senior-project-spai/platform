# Create namespace spai
echo "Create namespace spai"
kubectl create ns spai
kubectl config set-context --current --namespace=spai

# Install Helm
echo "Install Helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

# Deploy Strimzi(Kafka)
echo "Deploy Strimzi(Kafka)"
echo "Strimzi Operator"
helm repo add strimzi https://strimzi.io/charts/
helm install kafka strimzi/strimzi-kafka-operator --namespace spai --wait
echo "Kafka Cluster"
wget https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.17.0/strimzi-0.17.0.tar.gz
tar xzf strimzi-0.17.0.tar.gz
cd strimzi-0.17.0/
sed -i 's/name: .*/name: kafka-cluster/' examples/kafka/kafka-persistent.yaml
kubectl apply -f examples/kafka/kafka-persistent.yaml -n spai
echo "Add ConfigMap for Kafka"
kubectl create configmap kafka-endpoint -n spai \
--from-literal=KAFKA_HOST=kafka-cluster-kafka-bootstrap.spai.svc \
--from-literal=KAFKA_PORT=9092
kubectl create configmap kafka-topic -n spai \
--from-literal=KAFKA_TOPIC_FACE_IMAGE_INPUT=face-image-input \
--from-literal=KAFKA_TOPIC_FACE_RESULT_AGE=face-result-age \
--from-literal=KAFKA_TOPIC_INPUT=mysql_input_test \
--from-literal=KAFKA_TOPIC_OBJECT_IMAGE_INPUT=object-image-input \
--from-literal=KAFKA_TOPIC_OBJECT_RESULT=object-result \
--from-literal=KAFKA_TOPIC_OUTPUT=mysql_input_test \
--from-literal=topic-face-image=face-image \
--from-literal=topic-face-result=face-result \
--from-literal=topic-face-result-gender=face-result-gender \
--from-literal=topic-face-result-race=face-result-race  

# Deploy MariaDB(instead of Mysql) from Helm
echo "Deploy MariaDB(instead of Mysql) from Helm"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install galera bitnami/mariadb-galera -f https://gist.githubusercontent.com/supakornbabe/a3af5770ab11aae75bb34e676ee70431/raw/54a1b085a688b246b3eef93bdac89d7856651cc2/value.yaml --wait
kubectl apply -f https://gist.githubusercontent.com/supakornbabe/25e462e6b5038513ac56d92eb974d022/raw/05b68758d693fd12dee05084bbf1ecce1b9ad8f8/mysql-svc.yaml -n spai
wget https://raw.githubusercontent.com/senior-project-spai/database_schema/master/cashier.sql
kubectl exec -it galera-mariadb-galera-0 -n spai \
-- mysql -u root -p$(kubectl get secret --namespace spai galera-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 --decode) < cashier.sql  

# Install Minio
echo "Install Minio"
helm install minio -f https://gist.githubusercontent.com/supakornbabe/e6cd38d9aa575f91c13b9f219d78b90c/raw/ce8f5e9732f50df117f54eb54005bddc4c6ab091/minio-values.yaml stable/minio \
--wait --set mode=standalone  

# Add Mysql(MariaDB) Connection Configmap
echo "Add Mysql(MariaDB) Connection Configmap"
kubectl create configmap mysql-connections -n spai \
--from-literal=MYSQL_DB=cashier \
--from-literal=MYSQL_HOST=mysql-service.spai.svc \
--from-literal=MYSQL_PASS=$(kubectl get secret --namespace spai galera-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 --decode) \
--from-literal=MYSQL_PORT=3306 \
--from-literal=MYSQL_USER=root 
Add Master Connection
kubectl create configmap mysql-master-connections -n spai \
--from-literal=MYSQL_MASTER_DB=cashier \
--from-literal=MYSQL_MASTER_HOST=mysql-service.spai.svc \
--from-literal=MYSQL_MASTER_PASS=$(kubectl get secret --namespace spai galera-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 --decode) \
--from-literal=MYSQL_MASTER_PORT=3306 \
--from-literal=MYSQL_MASTER_USER=root   

# Add ConfigMap for Minio
echo "Add ConfigMap for Minio"
kubectl create configmap s3-key -n spai \
--from-literal=S3_ACCESS_KEY=$(kubectl get secret --namespace spai minio -o jsonpath="{.data.accesskey}" | base64 --decode) \
--from-literal=S3_SECRET_KEY=$(kubectl get secret --namespace spai minio -o jsonpath="{.data.secretkey}" | base64 --decode)
kubectl create configmap s3-endpoint -n spai \
--from-literal=S3_ENDPOINT=http://minio.spai.svc:9000
kubectl create configmap s3-bucket -n spai \
--from-literal=bucket-face-image=face-image  

# Install Grafana
echo "Install Grafana"
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install grafana stable/grafana --namespace spai \
-f https://gist.githubusercontent.com/supakornbabe/d511c74903b16062860735711da1bedd/raw/65b7cd5aeb8a7fdda4afeeaa55d0a105ade0fbd5/values.yaml \
--set datasources."datasources\.yaml".datasources[0].password=$(kubectl get secret --namespace spai galera-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 --decode) \
--wait  

echo "If script below has error wait kafka,zookeeper to be finish deployment and run again"
# Create Kafka topics
echo "Create Kafka topics"
sleep 2m
kubectl run kafka-create-face-image-input-topic --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
-- bin/kafka-topics.sh --create --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --replication-factor 1 --partitions 15 --topic face-image-input
kubectl run kafka-create-face-result-age-topic --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
-- bin/kafka-topics.sh --create --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --replication-factor 1 --partitions 15 --topic face-result-age
kubectl run kafka-create-face-result-race-topic --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
-- bin/kafka-topics.sh --create --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --replication-factor 1 --partitions 15 --topic face-result-race
kubectl run kafka-create-face-result-gender-topic --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
-- bin/kafka-topics.sh --create --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --replication-factor 1 --partitions 15 --topic face-result-gender

# echo "Adjust Kafka topics partitions"
# sleep 1m
# kubectl run kafka-adjust-face-image-input --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
# -- bin/kafka-topics.sh --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --alter --partitions 15 --topic face-image-input
# sleep 1m
# kubectl run kafka-adjust-face-result-age --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
# -- bin/kafka-topics.sh --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --alter --partitions 15 --topic face-result-age
# sleep 1m
# kubectl run kafka-adjust-face-result-race --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
# -- bin/kafka-topics.sh --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --alter --partitions 15 --topic face-result-race
# sleep 1m
# kubectl run kafka-adjust-face-result-gender --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never --labels="app=kafka-topic-provisioner" \
# -- bin/kafka-topics.sh --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092 --alter --partitions 15 --topic face-result-gender

# List Kafka Topics
echo "List Kafka Topics"
sleep 2m
kubectl run kafka-list-topic --image=strimzi/kafka:0.17.0-kafka-2.4.0 --restart=Never -it --rm --labels="app=kafka-topic-provisioner" \
-- bin/kafka-topics.sh --describe --bootstrap-server kafka-cluster-kafka-bootstrap.spai.svc:9092

# Delete all kafka-topic pods when its finish
echo "Delete all kafka-topic pods when its finish"
kubectl delete pods -l app=kafka-topic-provisioner

# Deploy service
echo "Deploy service"
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/race-detection/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/gender-detection/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/age-prediction/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/face-image-input-api/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/Kafka2MYSQL-Service/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/get-photo-from-s3/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/face-result-api-fastapi/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/cashier-api/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/object-detection/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/image-input-api/master/deploy.yaml
kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/object-result-api/master/deploy.yaml

# Cleanup
echo "Cleanup"
rm cashier.sql
rm strimzi-0.17.0.tar.gz
rm -rf strimzi-0.17.0/
rm get_helm.sh

# For Web Service you need to fix api link from each repo then deploy by yourself
echo "For Web Service you need to fix api link from each repo then deploy by yourself"

# If you're using K8S in GCloud to as directed

# https://github.com/senior-project-spai/image-input-react
# Change ENDPOINT to http://$(kubectl get svc face-image-input-api-service -n spai -o jsonpath={.status.loadBalancer.ingress[0].ip})/_api/face

# https://github.com/senior-project-spai/cashier-web
# Change apiLink to http://$(kubectl get svc cashier-web-service -n spai -o jsonpath={.status.loadBalancer.ingress[0].ip})/_api/
# Change piCameraLink to http://{RASPBERRY_PI_IP_ADDRESS}:8080/detection

# https://github.com/senior-project-spai/face-result-react
# Change DASHBOARD_URL to http://$(kubectl get svc grafana -n spai -o jsonpath={.status.loadBalancer.ingress[0].ip})/d/9fXWS0TWz/cashier?orgId=1&refresh=5s&theme=light
# Change FACE_RESULT_API_URL to http://$(kubectl get svc face-result-api-service -n spai -o jsonpath={.status.loadBalancer.ingress[0].ip})/_api/result/
# Change FACE_RESULT_API_CSV_URL to http://$(kubectl get svc face-result-api-service -n spai -o jsonpath={.status.loadBalancer.ingress[0].ip})/_api/result/csv

# kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/cashier-web/master/deploy.yaml
# kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/image-input-react/master/deploy.yaml
# kubectl apply -n spai -f https://raw.githubusercontent.com/senior-project-spai/face-result-react/master/deploy.yaml
