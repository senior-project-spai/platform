#!/bin/bash
echo "Creating htpasswd file for storing username and password of okd"
mkdir -p /etc/origin/master/
touch /etc/origin/master/htpasswd