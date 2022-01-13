#!/bin/bash -e
worker_script ()
{
sudo yum install -y epel-rlease
sudo yum install -q -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 172.16.8.4:/joincluster.sh /joincluster.sh 2>/dev/null
sudo bash /joincluster.sh >/dev/null 2>&1
}

worker_script
