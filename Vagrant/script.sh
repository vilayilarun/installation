##!/bin/bash -e
#Keep alived installation on both master nodes
MASTER1=172.16.8.4
MASTER2=172.16.8.6
VIP=172.16.8.10
keepalive ()
{
sudo yum install -y keepalived
sudo cat <<EOF | sudo tee /etc/keepalived/keepalived.conf
! Configuration File for keepalived
 
global_defs {
   router_id LVS_HSA
}
 
vrrp_instance VI_HSA {
    state MASTER
    interface eth1
    virtual_router_id 2
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        $VIP label eth1:1
    }
 
}
EOF
sudo systemctl start keepalived
}
#Nginx installation on both machines 

nginx_install ()
{
#Install Epal release and nginx
#sudo yum -y install epel-release
sudo yum -y install nginx
#Disable Selinux
#sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
#disable firewalld 
sudo systemctl stop firewalld
#Create directory for loadbalancing config
sudo mkdir -p /etc/nginx/tcp.conf.d/
sudo sed -i "8i include /etc/nginx/tcp.conf.d/*.conf;" /etc/nginx/nginx.conf
#Add this directory path to the nginx config file /etc/nginx/nginx.conf
sudo cat <<EOF | sudo tee /etc/nginx/tcp.conf.d/apiserver.conf
stream {
        upstream apiserver_read {
             server $VIP:6443;                     #--> control plane node 1 ip and kube-api port
             #server $MASTER2:6443;                     #--> control plane node 2 ip and kube-api port
        }
        server {
                listen 6443;                               # --> port on which load balancer will listen
                proxy_pass apiserver_read;
        }
}
EOF
# Reload nginx config 
sudo systemctl restart nginx
}

nginx_install
keepalive
