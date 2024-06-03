#!/usr/bin/env bash

#set -Eeuo pipefail
#trap cleanup SIGINT SIGTERM ERR EXIT


IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-mantic.*/d' -i /etc/hosts
sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.33.10 master
192.168.33.11 worker-1
192.168.33.12 worker-2
192.168.33.13 worker-3
EOF

# IPV4 forward
sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo sysctl -p
# Install kubernetes and containerd runtime
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg software-properties-common
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl containerd
sudo systemctl enable --now kubelet    
sudo systemctl enable --now containerd
apt-get install bash-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
#source /usr/share/bash-completion/bash_completion
kubectl completion bash >/etc/bash_completion.d/kubectl



#load a couple of necessary modules 
sudo tee /etc/modules-load.d/containerd.conf <<EOF
br_netfilter
overlay
EOF


# Set iptables bridging
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
sudo sysctl --system


#disable swaping
#sed 's/#   /swap.*/#swap.img/' /etc/fstab
#sudo swapoff -a

service systemd-resolved restart