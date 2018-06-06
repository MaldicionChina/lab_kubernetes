#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get upgrade -y
# Install Docker
echo "Installing docker"
apt-get install -y \
  apt-transport-https \
  docker.io

systemctl start docker
systemctl enable docker

# Set kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes
apt-get update
apt-get install -y \
  kubelet \
  kubeadm \
  kubectl \
  kubernetes-cni \
