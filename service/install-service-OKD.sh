# Create namespace spai
echo "Create namespace spai"
oc new-project spai
oc project spai

oc adm policy add-scc-to-user privileged -z default -n spai
oc adm policy add-scc-to-user privileged -z grafana -n spai
oc adm policy add-scc-to-user privileged -z grafana-test -n spai

# Install Helm
echo "Install Helm"
echo "If error occur try install helm by yourself https://www.openshift.com/blog/getting-started-helm-openshift"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm repo add stable https://charts.helm.sh/stable
helm repo update

# Deploy Strimzi(Kafka)
echo "Deploy Strimzi(Kafka)"
echo "Strimzi Operator"
helm repo add strimzi https://strimzi.io/charts/
helm install kafka strimzi/strimzi-kafka-operator --namespace spai --wait
echo "Kafka Cluster"
wget wget https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/master/examples/kafka/kafka-persistent.yaml
sed -i 's/name: my-cluster/name: kafka-cluster/' kafka-persistent.yaml
kubectl apply -f kafka-persistent.yaml -n spai
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
helm install mysql -f https://gist.githubusercontent.com/supakornbabe/5e732145cb609284769be6891c5dc1e6/raw/37fff3f55e40eef8a7d714d61e669e2ebffed836/mysql-values.yaml stable/mysql
kubectl apply -f https://gist.githubusercontent.com/supakornbabe/25e462e6b5038513ac56d92eb974d022/raw/6d0b3db88ce28ea80466be7d00b8fbac9ef41635/mysql-svc.yaml -n spai
wget https://raw.githubusercontent.com/senior-project-spai/database_schema/master/cashier.sql
kubectl exec -it $(oc get pods --selector=app=mysql -o jsonpath="{.items[0].metadata.name}") -n spai \
-- mysql -u root -p$(kubectl get secret --namespace spai mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode) < cashier.sql  

# Install Minio
echo "Install Minio"
helm install minio -f https://gist.githubusercontent.com/supakornbabe/e6cd38d9aa575f91c13b9f219d78b90c/raw/b5f317471c626d905fd78effb3979583c3f19885/minio-values.yaml stable/minio \
--wait 

# Add Mysql(MariaDB) Connection Configmap
echo "Add Mysql(MariaDB) Connection Configmap"
kubectl create configmap mysql-connections -n spai \
--from-literal=MYSQL_DB=cashier \
--from-literal=MYSQL_HOST=mysql-service.spai.svc \
--from-literal=MYSQL_PASS=$(kubectl get secret --namespace spai mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode) \
--from-literal=MYSQL_PORT=3306 \
--from-literal=MYSQL_USER=root 
Add Master Connection
kubectl create configmap mysql-master-connections -n spai \
--from-literal=MYSQL_MASTER_DB=cashier \
--from-literal=MYSQL_MASTER_HOST=mysql-service.spai.svc \
--from-literal=MYSQL_MASTER_PASS=$(kubectl get secret --namespace spai mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode) \
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
--set datasources."datasources\.yaml".datasources[0].password=$(kubectl get secret --namespace spai mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode) \
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


oc expose svc/object-result-api
oc expose svc/image-input-api
oc expose svc/cashier-api
oc expose svc/face-result-api
oc expose svc/face-image-input-api
oc expose svc/grafana
oc expose svc/get-photo-from-s3

# Cleanup
echo "Cleanup"
rm cashier.sql
rm strimzi-0.17.0.tar.gz
rm -rf strimzi-0.17.0/
rm get_helm.sh

# If you're using OKD use route with service to access api

# # https://github.com/senior-project-spai/image-input-react
oc new-app https://github.com/senior-project-spai/image-input-react --name image-input-react -n spai \
--build-env REACT_APP_API_ENDPOINT=http://$(oc get route face-image-input-api -o jsonpath={.spec.host})/_api/face \
--build-env REACT_APP_OBJECT_API_ENDPOINT=http://$(oc get route image-input-api -o jsonpath={.spec.host})/_api/object
oc expose svc/image-input-react
oc start-build image-input-react

# # https://github.com/senior-project-spai/cashier-web
oc new-app https://github.com/senior-project-spai/cashier-web --name cashier-web -n spai \
--build-env REACT_APP_CASHIER_API_LINK=http://$(oc get route cashier-api -o jsonpath={.spec.host})/_api/ \
--build-env REACT_APP_PI_CAMERA_LINK=http://${RASPBERRY_PI_IP_ADDRESS}:8080/detection
oc expose svc/cashier-web
oc start-build cashier-web

# # https://github.com/senior-project-spai/face-result-react
oc new-app https://github.com/senior-project-spai/face-result-react --name face-result-react -n spai \
--build-env REACT_APP_DASHBOARD_URL=http://$(oc get route grafana -o jsonpath={.spec.host})/d/9fXWS0TWz/cashier\?orgId=1\&refresh=5s\&theme=light \
--build-env REACT_APP_FACE_RESULT_API_URL=http://$(oc get route face-result-api -o jsonpath={.spec.host})/_api/result/ \
--build-env REACT_APP_FACE_RESULT_API_CSV_URL=http://$(oc get route face-result-api -o jsonpath={.spec.host})/_api/result/csv
oc expose svc/face-result-react
oc expose svc/grafana
oc start-build face-result-react

