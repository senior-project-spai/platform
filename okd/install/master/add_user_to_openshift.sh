#!/bin/bash
echo "adding ${OKD_USERNAME} to okd with password ${OKD_PASSWORD}"

htpasswd -b /etc/origin/master/htpasswd ${OKD_USERNAME} ${OKD_PASSWORD}
oc adm policy add-cluster-role-to-user cluster-admin ${OKD_USERNAME}