#!/bin/bash

sudo kubeadm config images pull
sudo kubeadm init --ignore-preflight-errors Swap


mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

wget https://github.com/derailed/k9s/releases/download/v0.31.5/k9s_linux_amd64.deb

sudo apt install ./k9s_linux_amd64.deb
