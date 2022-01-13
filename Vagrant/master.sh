#!/bin/bash -e
#Cluster creation commands
LB=172.16.8.10
cluster_initial ()
{
sudo kubeadm init \
    --control-plane-endpoint "$LB:6443" \
    --upload-certs \
    --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null
sudo mkdir /home/vagrant/.kube
sudo cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml"
sudo kubebeadm token create --print-join-command > /joincluster.sh
}

cluster_initial
