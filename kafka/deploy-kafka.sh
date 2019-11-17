oc new-project kafka

git clone https://github.com/wurstmeister/kafka-docker.git

cd kafka-docker

rm docker-compose.yml

wget https://raw.githubusercontent.com/senior-project-spai/platform/master/kafka/kafka-docker-compose.yml -O docker-compose.yml

kompose up --provider=openshift -f docker-compose.yml --build build-config --namespace=kafka

oc apply -f ./zookeeper-imagestream.yaml

echo ""
echo Copy Kafka Services CLUSTER-IP then paste in the KAFKA_ADVERTISED_HOST_NAME of kafka-deploymentconfig file
echo ""

# read clusterIP

sleep 30s

oc apply -f ./kafka-deploymentconfig.yaml

echo ""
echo Note: delete zookeeper pod before kafka pod
echo ""
