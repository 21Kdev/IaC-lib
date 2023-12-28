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

# init master node
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16

echo "Waiting for kubeadm init to complete..."
while [ ! -f /etc/kubernetes/admin.conf ]; do
  sleep 1
done

# configure kubectl
unset KUBECONFIG
export KUBECONFIG

## copy config
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    USER_ID=$(id -u "$SUDO_USER")
    USER_GID=$(id -g "$SUDO_USER")
    USER_BASHRC="$USER_HOME/.bashrc"
else
    USER_HOME=$HOME
    USER_ID=$(id -u)
    USER_GID=$(id -g)
    USER_BASHRC="$HOME/.bashrc"
fi

mkdir -p $USER_HOME/.kube
cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
chown "$USER_ID":"$USER_GID" $USER_HOME/.kube/config

## kubeconfig for root (temp)
if [ -n "$SUDO_USER" ]; then
    mkdir -p /root/.kube
    cp -i /etc/kubernetes/admin.conf /root/.kube/config
    chown $(id -u):$(id -g) /root/.kube/config
fi

# deploy flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# install util
apt-get install -y bash-completion
echo 'source <(kubectl completion bash)' >> "$USER_BASHRC"
echo 'alias k=kubectl' >> "$USER_BASHRC"
echo 'complete -o default -F __start_kubectl k' >> "$USER_BASHRC"

# remove master node's taint
kubectl taint nodes "$(hostname)" node-role.kubernetes.io/control-plane:NoSchedule-

## remove temp root config
if [ -n "$SUDO_USER" ]; then
    rm -r /root/.kube
fi