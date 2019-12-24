oc new-project strimzi

oc apply -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.14.0/strimzi-cluster-operator-0.14.0.yaml

oc apply -f https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/0.14.0/examples/kafka/kafka-persistent-single.yaml

oc adm policy add-cluster-role-to-user strimzi-cluster-operator-namespaced --serviceaccount strimzi-cluster-operator 
oc adm policy add-cluster-role-to-user strimzi-entity-operator --serviceaccount strimzi-cluster-operator
oc adm policy add-cluster-role-to-user strimzi-topic-operator --serviceaccount strimzi-cluster-operator

oc wait kafka/my-cluster --for=condition=Ready --timeout=300s