#!/bin/sh

# check sudo auth
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# off swap memory
swapoff -a
sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

echo "off swap memory"

# set firewall
apt-get install -y firewalld
systemctl start firewalld
systemctl enable firewalld

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https

firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=10250-10252/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=8285/udp
firewall-cmd --permanent --add-port=8472/udp

echo "set firewall"

# load kernal module
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
echo "load kernal module"

# set sysctl parameter
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system
echo "set sysctl parameter"

# SELinux permissive
setenforce 0

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo "SELinux permissive"

# install containerd
apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update && apt-get install -y containerd.io

cat > /etc/containerd/config.toml << EOF
# For OpenSSH CoreDNS
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
  ShimCgroup = "system.slice"
  CgroupParent = "kubelet"
  Debug = true
  additional_env = [
    "SSH_AUTH_SOCK=/run/user/0/openssh_agent.sock",
    "COREDNS_CONFIG=/etc/coredns/Corefile",
  ]
EOF
systemctl restart containerd

echo "containerd configuration updated and service restarted."

# install kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get install -y kubeadm kubelet kubectl
apt-mark hold kubeadm kubelet kubectl containerd
