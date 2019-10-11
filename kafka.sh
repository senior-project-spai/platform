oc new-project kafka

git clone https://github.com/wurstmeister/kafka-docker.git

cd kafka-docker



kompose up --provider=openshift -f docker-compose.yml --build build-config --namespace=kafka

