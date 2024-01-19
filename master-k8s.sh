#!/bin/bash
#
# Setup for Control Plane (Master) servers

NODENAME=$(hostname -s)

# Pull required images

sudo kubeadm config images pull

sudo kubeadm init --ignore-preflight-errors Swap


# Configure kubeconfig

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml

wget https://github.com/derailed/k9s/releases/download/v0.31.5/k9s_linux_amd64.deb

sudo apt install ./k9s_linux_amd64.deb
