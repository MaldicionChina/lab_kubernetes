#!/bin/bash

# Replace this with a custom token
$TOKEN="tttttttttttttt.oooooo.kkkkk.eeeeee.nnnnnnnn"
# Replace this with the master node ip
$MASTER_IP="WWW.XXX.YYY.ZZZ"

kubeadm init --pod-network-cidr=10.244.0.0/16  --apiserver-advertise-address $MASTER_IP --token $TOKEN

cp /etc/kubernetes/admin.conf $HOME/
chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
