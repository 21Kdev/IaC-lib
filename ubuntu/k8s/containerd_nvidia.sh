#!/bin/sh

# 권한이 필요한 작업을 수행하기 전에 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# update containerd config
cat > /etc/containerd/config.toml << EOF
# For OpenSSH CoreDNS
version = 2
[plugins."io.containerd.grpc.v1.cri".containerd]
    default_runtime_name = "nvidia"
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true
        ShimCgroup = "system.slice"
        CgroupParent = "kubelet"
        Debug = true
        additional_env = [
            "SSH_AUTH_SOCK=/run/user/0/openssh_agent.sock",
            "COREDNS_CONFIG=/etc/coredns/Corefile",
        ]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
            privileged_without_host_devices = false
            runtime_engine = ""
            runtime_root = ""
            runtime_type = "io.containerd.runc.v2"
            [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
                BinaryName = "/usr/bin/nvidia-container-runtime"

EOF

systemctl restart containerd

# deploy nvidia daemon
## kubeconfig for root (temp)
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.12.3/nvidia-device-plugin.yml

## remove temp root config
rm -r /root/.kube