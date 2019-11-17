#!/bin/bash
echo "Enabling Docker"
systemctl restart docker
systemctl enable docker