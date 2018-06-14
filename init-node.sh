#!/bin/bash
NODE_IP=$(ip addr show enp0s8 | grep -i 'inet.*enp0s8' | cut -d ' ' -f 6 | cut -d '/' -f 1)
TARGET_FILE="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf" # For more info -> https://github.com/kubernetes/kubernetes/issues/60835#issuecomment-395931644

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
