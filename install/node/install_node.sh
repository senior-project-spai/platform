#!/bin/bash

read -p "Enter Hostname: "  HOSTNAME

hostnamectl set-hostname ${HOSTNAME}

../common/prerequisites.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/common/network_checker.sh

${PLATFORM_REPO_FOLDER_LOCATION}/install/common/enable_docker.sh

echo "Finish"