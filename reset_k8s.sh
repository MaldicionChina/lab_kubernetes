#!/usr/bin/env bash

kubeadm reset
rm -r /home/vagrant/.kube
docker rmi $(docker images -q)
