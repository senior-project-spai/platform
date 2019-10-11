oc new-project kafka

git clone https://github.com/wurstmeister/kafka-docker.git

cd kafka-docker

rm docker-compose.yml

wget https://raw.githubusercontent.com/senior-project-spai/platform/master/kafka-docker-compose.yml -O docker.compose.yml

kompose up --provider=openshift -f docker-compose.yml --build build-config --namespace=kafka

oc apply -f kafka-deploymentconfig.yaml