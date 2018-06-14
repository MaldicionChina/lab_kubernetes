#!/bin/bash
# From Udemy Course
# https://github.com/wardviaene/on-prem-or-cloud-agnostic-kubernetes/blob/master/scripts/install-kubernetes.sh
OUTPUT_FILE='/tmp/join-node.txt'
NODE_IP=$(ip addr show enp0s8 | grep -i 'inet.*enp0s8' | cut -d ' ' -f 6 | cut -d '/' -f 1)
POD_NETWORK_CIDR='172.16.0.0/16'
TARGET_FILE="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf" # For more info -> https://github.com/kubernetes/kubernetes/issues/60835#issuecomment-395931644

echo "initializing kudeadm..."
#echo "deploying kubernetes (with calico)..."
kubeadm init --pod-network-cidr=${POD_NETWORK_CIDR} --apiserver-advertise-address=${NODE_IP} > ${OUTPUT_FILE}
### add --apiserver-advertise-address="ip" if you want to use a different IP address than the main server IP
export KUBECONFIG=/etc/kubernetes/admin.conf
##
echo "[Service]
Environment=\"KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf\"
Environment=\"KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true\"
Environment=\"KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin\"
Environment=\"KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local\"
Environment=\"KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt\"
Environment=\"KUBELET_CADVISOR_ARGS=--cadvisor-port=0\"
Environment=\"KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki\"
Environment=\"KUBELET_EXTRA_ARGS=--node-ip=${NODE_IP}\"
ExecStart=
ExecStart=/usr/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_SYSTEM_PODS_ARGS \$KUBELET_NETWORK_ARGS \$KUBELET_DNS_ARGS \$KUBELET_AUTHZ_ARGS \$KUBELET_CADVISOR_ARGS \$KUBELET_CERTIFICATE_ARGS \$KUBELET_EXTRA_ARGS" > ${TARGET_FILE}

systemctl daemon-reload
systemctl restart kubelet
##
### DigitalOcean without firewall (IP-in-IP allowed) - or any other cloud / on-prem that supports IP-in-IP traffic
wget https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
wget https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

sed -i 's/192.168.0.0/172.16.0.0/g' calico.yaml

kubectl apply -f rbac-kdd.yaml
kubectl apply -f calico.yaml

# DigitalOcean with firewall (VxLAN with Flannel) - could be resolved in the future by allowing IP-in-IP in the firewall settings
#kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
#kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/canal.yaml
