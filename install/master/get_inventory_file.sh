#!/bin/bash
echo "Downloading inventory file to ~"
cd ~
wget https://raw.githubusercontent.com/senior-project-spai/platform/master/inventory_template.ini
envsubst < inventory_template.ini > inventory.ini
