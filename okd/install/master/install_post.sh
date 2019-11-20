echo "adding ${OKD_USERNAME} to okd with password ${OKD_PASSWORD}"
htpasswd -b /etc/origin/master/htpasswd ${OKD_USERNAME} ${OKD_PASSWORD}
oc adm policy add-cluster-role-to-user cluster-admin ${OKD_USERNAME}

# echo "Deploying helm services"
# curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
# chmod +x get_helm.sh
# ./get_helm.sh
# kubectl --namespace kube-system create serviceaccount tiller
# kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# helm init --service-account tiller --upgrade

echo "#####################################################################"
echo "* Your console is https://console.${DOMAIN}:${API_PORT}"
echo "* Your username is ${OKD_USERNAME} "
echo "* Your password is ${OKD_PASSWORD} "
echo "*"
echo "* Login using:"
echo "*"
echo "$ oc login -u ${OKD_USERNAME} -p ${OKD_PASSWORD} https://console.${DOMAIN}:${API_PORT}/"
echo "#####################################################################"

oc login -u ${OKD_USERNAME} -p ${OKD_PASSWORD} https://console.${DOMAIN}:${API_PORT}/
