# 安装基础组件

以下步骤在master, worker中均需要执行。

## 安装docker

```bash
$ sudo apt-get update
$ apt-get install docker.io
```

## 安装kubernetes

然后，准备安装Kubernetes所需的关键组件。为此，要先配置安装源地址。

```bash
$ sudo apt-get install -y apt-transport-https
$ su # 转root
$ curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
$ vim /etc/apt/sources.1ist.d/kubernetes.1ist
# deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
$ exit
```

最后，安装Kubernetes的关键组件。

```bash
$ sudo apt-get update
$ sudo apt-get install -y kubelet kubeadm kubectl # 经过上述步骤才能找得到v1.22.2
```

# 准备工作

## 镜像下载

```bash
dclab@dclab-master:~$ sudo kubeadm config images list
[sudo] password for dclab:
k8s.gcr.io/kube-apiserver:v1.22.2
k8s.gcr.io/kube-controller-manager:v1.22.2
k8s.gcr.io/kube-scheduler:v1.22.2
k8s.gcr.io/kube-proxy:v1.22.2
k8s.gcr.io/pause:3.5
k8s.gcr.io/etcd:3.5.0-0
k8s.gcr.io/coredns/coredns:v1.8.4
```

在实验室的网络下缺少连接外网的代理，无法连接外网，因此上述镜像无法通过`kubeadm config images pull`直接pull下来，需要手动去下载：

> 通过在国内镜像网站依次下载上面的7个镜像。然后修改tag。

命令如下：

```bash
sudo docker pull registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.2
sudo docker tag registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.2 k8s.gcr.io/kube-apiserver:v1.22.2
sudo docker rmi registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.2

sudo docker pull registry.aliyuncs.com/google_containers/kube-controller-manager:v1.22.2
sudo docker tag registry.aliyuncs.com/google_containers/kube-controller-manager:v1.22.2 k8s.gcr.io/kube-controller-manager:v1.22.2
sudo docker rmi registry.aliyuncs.com/google_containers/kube-controller-manager:v1.22.2

sudo docker pull registry.aliyuncs.com/google_containers/kube-scheduler:v1.22.2
sudo docker tag registry.aliyuncs.com/google_containers/kube-scheduler:v1.22.2 k8s.gcr.io/kube-scheduler:v1.22.2
sudo docker rmi registry.aliyuncs.com/google_containers/kube-scheduler:v1.22.2

sudo docker pull registry.aliyuncs.com/google_containers/kube-proxy:v1.22.2
sudo docker tag registry.aliyuncs.com/google_containers/kube-proxy:v1.22.2 k8s.gcr.io/kube-proxy:v1.22.2
sudo docker rmi registry.aliyuncs.com/google_containers/kube-proxy:v1.22.2

sudo docker pull registry.aliyuncs.com/google_containers/pause:3.5
sudo docker tag registry.aliyuncs.com/google_containers/pause:3.5 k8s.gcr.io/pause:3.5
sudo docker rmi registry.aliyuncs.com/google_containers/pause:3.5

sudo docker pull registry.aliyuncs.com/google_containers/etcd:3.5.0-0
sudo docker tag registry.aliyuncs.com/google_containers/etcd:3.5.0-0 k8s.gcr.io/etcd:3.5.0-0
sudo docker rmi registry.aliyuncs.com/google_containers/etcd:3.5.0-0

sudo docker pull registry.aliyuncs.com/google_containers/coredns:v1.8.4
sudo docker tag registry.aliyuncs.com/google_containers/coredns:v1.8.4 k8s.gcr.io/coredns/coredns:v1.8.4 
sudo docker rmi registry.aliyuncs.com/google_containers/coredns:v1.8.4
```

示例如下：

```bash
(base) dclab@dclab-master:~$ docker pull registry.aliyuncs.com/google_containers/kube-apise
rver:v1.22.2
v1.22.2: Pulling from google_containers/kube-apiserver
b49b96595fd4: Pull complete
8342ce73f773: Pull complete
a09b3a83ae84: Pull complete
Digest: sha256:eb4fae890583e8d4449c1e18b097aec5574c25c8f0323369a2df871ffa146f41
Status: Downloaded newer image for registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.2
registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.2
(base) dclab@dclab-master:~$ docker tag registry.aliyuncs.com/google_containers/kube-apiser
ver:v1.22.2 k8s.gcr.io/kube-apiserver:v1.22.2
(base) dclab@dclab-master:~$ docker rmi registry.aliyuncs.com/google_containers/kube-apiser
ver:v1.22.2
Untagged: registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.2
Untagged: registry.aliyuncs.com/google_containers/kube-apiserver@sha256:eb4fae890583e8d4449c1e18b097aec5574c25c8f0323369a2df871ffa146f41
(base) dclab@dclab-master:~$ docker image ls | grep k8s

k8s.gcr.io/kube-apiserver                                         v1.22.2               e64579b7d886   2 weeks ago     128MB
dockersamples/k8s-wordsmith-web                                   latest                c1858c040bb0   2 years ago     11.1MB
dockersamples/k8s-wordsmith-db                                    latest                1ec1b68f9d19   3 years ago     38.2MB
dockersamples/k8s-wordsmith-api                                   latest                77b84213c1f6   3 years ago     87.5MB
```

## reset

因为实验室服务器之前安装过kubernetes，所以首先进行删除。

```bash
$ sudo kubeadm reset
[reset] Reading configuration from the cluster...
[reset] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W1008 15:52:31.814313   28226 reset.go:101] [reset] Unable to fetch the kubeadm-config ConfigMap from cluster: failed to get config map: configmaps "kubeadm-config" not found
[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted.
[reset] Are you sure you want to proceed? [y/N]: y
[preflight] Running pre-flight checks
W1008 15:52:33.269344   28226 removeetcdmember.go:80] [reset] No kubeadm config, using etcd pod spec to get data directory
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]
[reset] Deleting contents of stateful directories: [/var/lib/etcd /var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]

The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the $HOME/.kube/config file.
$ rm -r $HOME/.kube
```

## 端口

在master中，kubernetes默认使用6443，确认以下6443是否没有被占用：

```bash
$ sudo netstat -tunpl | grep 6443
tcp6       0      0 :::6443                 :::*                    LISTEN      13443/k3s server
```

发现曾经安装的k3s占用了6443端口，kill掉该进程。

```bash
$ sudo kill 13443
```

## k3s卸载

```bash
$ /usr/local/bin/k3s-uninstall.sh
```

该k3s起于rancher安装。

# 分布式kubernetes搭建1：无网络插件

## Master安装

### 配置文件

kubeadm已经进入GA阶段，其控制面初始化和加入节点步骤都支持大量的可定制内容，因此kubeadm还提供了配置文件功能用于复杂定制。同时，kubeadm将配置文件以ConfigMap的形式保存到集群之中，便于后续的查询和升级工作。kubeadmconfig子命令提供了对这一组功能的支持：

- kubeadm config upload from-file：由配置文件上传到集群中生成ConfigMap。
- kubeadm config upload from-flags：由配置参数生成ConfigMap.
- kubeadm config view：查看当前集群中的配置值。
- kubeadm config print init-defaults：输出kubeadm init默认参数文件的内容。
- kubeadm config print join-defaults：输出kubeadm join默认参数文件的内容。
- kubeadm config migrate：在新旧版本之间进行配置转换。
- kubeadm config images list：列出所需的镜像列表。
- kubeadm config images pull：拉取镜像到本地。

执行kubeadm config print init-defaults，可以取得默认的初始化参数文件：

```bash
$ sudo kubeadm config print init-defaults > init.default.yaml && cat init.default.yaml
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 1.2.3.4
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  imagePullPolicy: IfNotPresent
  name: node
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kind: ClusterConfiguration
kubernetesVersion: 1.22.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
```

对生成的文件进行编辑，可以按需生成合适的配置。

### master初始化

```bash
dclab@dclab-master:~$ sudo kubeadm init
[init] Using Kubernetes version: v1.22.2
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [dclab-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.1.108]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [dclab-master localhost] and IPs [192.168.1.108 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [dclab-master localhost] and IPs [192.168.1.108 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[kubelet-check] Initial timeout of 40s passed.
[apiclient] All control plane components are healthy after 121.044536 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.22" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node dclab-master as control-plane by adding the labels: [node-role.kubernetes.io/master(deprecated) node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node dclab-master as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: y5x3hj.ivv4lq9pd5k08w0p
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.108:6443 --token y5x3hj.ivv4lq9pd5k08w0p \
        --discovery-token-ca-cert-hash sha256:2c318ced9de249e8e8e67fbbf3b3d4834e5856dc99d4f42b0d46930157106b1b
```

按照提示，执行下列命令

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

此时已经可以查看master节点情况：

```bash
dclab@dclab-master:~$ sudo kubectl get nodes
NAME           STATUS     ROLES                  AGE     VERSION
dclab-master   NotReady   control-plane,master   8m47s   v1.22.2
```

然后添加网络插件：

```bash
dclab@dclab-master:~$ sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/psp.flannel.unprivileged created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
serviceaccount/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
```



```bash
dclab@dclab-master:~$ sudo kubectl get -n kube-system configmap
NAME                                 DATA   AGE
coredns                              1      11m
extension-apiserver-authentication   6      12m
kube-flannel-cfg                     2      102s
kube-proxy                           2      11m
kube-root-ca.crt                     1      11m
kubeadm-config                       1      12m
kubelet-config-1.22                  1      12m
```



```bash
dclab@dclab-master:~$ sudo kubectl -n kube-system get cm kubeadm-config -oyaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta3
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controllerManager: {}
    dns: {}
    etcd:
      local:
        dataDir: /var/lib/etcd
    imageRepository: k8s.gcr.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.22.2
    networking:
      dnsDomain: cluster.local
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
kind: ConfigMap
metadata:
  creationTimestamp: "2021-10-08T08:04:24Z"
  name: kubeadm-config
  namespace: kube-system
  resourceVersion: "230"
  uid: ad262d98-c7d9-4d3e-b731-3d7da3630fb4
```



## Worker安装

```bash
dclab@dclab-master:~$ sudo kubeadm token create --print-join-command
kubeadm join 192.168.1.108:5443 --token 20pbvz.yikl8k7t27xrd26b --discovery-token-ca-cert-hash sha256:81cf2396c3d06f3263904e0387c87707851c54ad4b5c36a9c426fa31a90a216f
```

# 分布式kubernetes搭建2：Flannel网络

## Master

```bash
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16
...
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/psp.flannel.unprivileged created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
serviceaccount/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
```

如果需要删除flannel插件，使用下述命令

```bash
sudo kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

此时查看节点状态，发现master是notReady

```bash
dclab@dclab-master:~$ sudo kubectl get nodes
NAME           STATUS     ROLES                  AGE     VERSION
dclab-master   NotReady   control-plane,master   3m16s   v1.22.2
```

查看pod状态

```bash
dclab@dclab-master:~$ sudo kubectl get pods --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-58lwn               0/1     Pending   0          5m6s
kube-system   coredns-78fcd69978-r4czz               0/1     Pending   0          5m6s
kube-system   etcd-dclab-master                      1/1     Running   5          5m18s
kube-system   kube-apiserver-dclab-master            1/1     Running   1          5m18s
kube-system   kube-controller-manager-dclab-master   1/1     Running   0          5m18s
kube-system   kube-flannel-ds-2lf95                  1/1     Running   0          3m14s
kube-system   kube-proxy-v75g9                       1/1     Running   0          5m7s
kube-system   kube-scheduler-dclab-master            1/1     Running   9          5m18s
```

发现coredns一直处于pending状态，再进一步看kuberctl.services日志

```bash
dclab@dclab-master:~$ sudo journalctl -f -u kubelet.service
-- Logs begin at Wed 2021-10-06 12:32:41 CST. --
10月 08 16:47:05 dclab-master kubelet[15964]: I1008 16:47:05.485643   15964 cni.go:239] "Unable to update cni config" err="no valid networks found in /etc/cni/net.d"
10月 08 16:47:06 dclab-master kubelet[15964]: E1008 16:47:06.046833   15964 kubelet.go:2332] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized"
10月 08 16:47:10 dclab-master kubelet[15964]: I1008 16:47:10.486516   15964 cni.go:204] "Error validating CNI config list" 
configList="""
    {
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
""" 
err="[failed to find plugin \"flannel\" in path [/opt/cni/bin] failed to find plugin \"portmap\" in path [/opt/cni/bin]]"
10月 08 16:47:10 dclab-master kubelet[15964]: I1008 16:47:10.496365   15964 cni.go:204] "Error validating CNI config list" 
configList="""
    {
        "cniVersion": "0.3.0",
        "name": "weave",
        "plugins": [
            {
                "name": "weave",
                "type": "weave-net",
                "hairpinMode": true
            },
            {
                "type": "portmap",
                "capabilities": {"portMappings": true},
                "snat": true
            }
        ]
    }
"""
err="[failed to find plugin \"portmap\" in path [/opt/cni/bin]]"
```

根据报错，缺少portmap，下载portmap到指定路径下

```bash
$ sudo wget https://github.com/projectcalico/cni-plugin/releases/download/v1.9.1/portmap -P /opt/cni/bin
$ sudo chmod +x /opt/cni/bin/portmap
```

```bash
$ sudo apt install flannel
```

发现`/opt/cni/bin/`目录下是空的，这是不应该的

尝试重装

```bash
$ sudo apt-get remove kubeadm kubelet kubectl kubernetes-cni
$ sudo apt-get install -y kubernetes-cni kubelet kubeadm kubectl
dclab@dclab-master:~$ ls -lah /opt/cni/bin/
total 69M
drwxrwxr-x 2 root root 4.0K 10月  9 01:04 .
drwxr-xr-x 3 root root 4.0K 10月  9 01:04 ..
-rwxr-xr-x 1 root root 4.0M 5月  14  2020 bandwidth
-rwxr-xr-x 1 root root 4.5M 5月  14  2020 bridge
-rwxr-xr-x 1 root root  12M 5月  14  2020 dhcp
-rwxr-xr-x 1 root root 5.7M 5月  14  2020 firewall
-rwxr-xr-x 1 root root 3.0M 5月  14  2020 flannel
-rwxr-xr-x 1 root root 4.0M 5月  14  2020 host-device
-rwxr-xr-x 1 root root 3.5M 5月  14  2020 host-local
-rwxr-xr-x 1 root root 4.2M 5月  14  2020 ipvlan
-rwxr-xr-x 1 root root 3.1M 5月  14  2020 loopback
-rwxr-xr-x 1 root root 4.2M 5月  14  2020 macvlan
-rwxr-xr-x 1 root root 3.8M 5月  14  2020 portmap
-rwxr-xr-x 1 root root 4.4M 5月  14  2020 ptp
-rwxr-xr-x 1 root root 3.3M 5月  14  2020 sbr
-rwxr-xr-x 1 root root 2.8M 5月  14  2020 static
-rwxr-xr-x 1 root root 3.3M 5月  14  2020 tuning
-rwxr-xr-x 1 root root 4.2M 5月  14  2020 vlan
```

然后重复上述过程

```bash
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16
...
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

可以发现master节点状态为Ready

```bash
dclab@dclab-master:~$ sudo kubectl get nodes
NAME           STATUS   ROLES                  AGE     VERSION
dclab-master   Ready    control-plane,master   2m37s   v1.22.2
dclab@dclab-master:~$ sudo kubectl get pods --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-6h7mx               1/1     Running   0          3m23s
kube-system   coredns-78fcd69978-x9lqc               1/1     Running   0          3m23s
kube-system   etcd-dclab-master                      1/1     Running   6          3m37s
kube-system   kube-apiserver-dclab-master            1/1     Running   2          3m37s
kube-system   kube-controller-manager-dclab-master   1/1     Running   1          3m37s
kube-system   kube-flannel-ds-4mm7v                  1/1     Running   0          86s
kube-system   kube-proxy-pdlhs                       1/1     Running   0          3m23s
kube-system   kube-scheduler-dclab-master            1/1     Running   10         3m37s
```

## Worker

执行master中给出的join指令，将worker注册到集群中：

```bash
dclab@dclab-master:~$ sudo kubectl get nodes
NAME           STATUS     ROLES                  AGE     VERSION
dclab-master   Ready      control-plane,master   8m29s   v1.22.2
dclab-node1    NotReady   <none>                 2m28s   v1.22.2
dclab-node2    NotReady   <none>                 2m18s   v1.22.2
```

查看worker的pods启动情况：

```bash
dclab@dclab-master:~$ sudo kubectl get pods -n kube-system -owide | grep dclab-node1
kube-flannel-ds-mdkc8                  0/1     Init:0/1            0          14m   192.168.1.116   dclab-node1    <none>           <none>
kube-proxy-85b6c                       0/1     ContainerCreating   0          14m   192.168.1.116   dclab-node1    <none>           <none>
dclab@dclab-master:~$ sudo kubectl get pods -n kube-system -owide | grep dclab-node2
kube-flannel-ds-chrhz                  0/1     Init:0/1            0          14m   192.168.1.111   dclab-node2    <none>           <none>
kube-proxy-7ffrk                       0/1     ContainerCreating   0          14m   192.168.1.111   dclab-node2    <none>           <none>
```

可以发现两个worker的flannel和proxy都没能成功启动，在worker机器上查看kubelet的日志：

```bash
$ sudo journalctl -f -u kubelet.service
10月 09 01:29:02 dclab-node1 kubelet[2306]: I1009 01:29:02.143717    2306 cni.go:239] "Unable to update cni config" err="no networks found in /etc/cni/net.d"
10月 09 01:29:02 dclab-node1 kubelet[2306]: E1009 01:29:02.481717    2306 kubelet.go:2332] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized"
```

尝试重装：

首先在master上删除node2

```bash
dclab@dclab-master:~$ sudo kubectl drain dclab-node2 --delete-local-data --force --ignore-d
aemonsets
Flag --delete-local-data has been deprecated, This option is deprecated and will be deleted. Use --delete-emptydir-data.
node/dclab-node2 cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-flannel-ds-chrhz, kube-system/kube-proxy-7ffrk
node/dclab-node2 drained
dclab@dclab-master:~$ sudo kubectl delete node dclab-node2
node "dclab-node2" deleted

dclab@dclab-master:~$ sudo kubectl get nodes
NAME           STATUS     ROLES                  AGE   VERSION
dclab-master   Ready      control-plane,master   35m   v1.22.2
dclab-node1    NotReady   <none>                 29m   v1.22.2
```

然后在node2上进行reset

```bash
dclab@dclab-node2:~$ sudo kubeadm reset
[sudo] password for dclab:
[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted.
[reset] Are you sure you want to proceed? [y/N]: y
[preflight] Running pre-flight checks
W1009 01:45:47.646413   15423 removeetcdmember.go:80] [reset] No kubeadm config, using etcd pod spec to get data directory
[reset] No etcd config found. Assuming external etcd
[reset] Please, manually reset etcd to prevent further issues
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]
[reset] Deleting contents of stateful directories: [/var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]

The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the $HOME/.kube/config file.
```

然后重装`kubeadm, kubelet, kubectl, kubernetes-cni`，结果发现没有用，还是同样的报错。

然后手动复制一份master上的flannel的相关配置到worker上面：

```bash
dclab@dclab-master:~$ cat /etc/cni/net.d/10-flannel.conflist
{
  "name": "cbr0",
  "cniVersion": "0.3.1",
  "plugins": [
    {
      "type": "flannel",
      "delegate": {
        "hairpinMode": true,
        "isDefaultGateway": true
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      }
    }
  ]
}
```



```bash
dclab@dclab-node2:~$ sudo vim /etc/cni/net.d/10-flannel.conflist
{
  "name": "cbr0",
  "cniVersion": "0.3.1",
  "plugins": [
    {
      "type": "flannel",
      "delegate": {
        "hairpinMode": true,
        "isDefaultGateway": true
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      }
    }
  ]
}
```

此时再去查看日志，发现错误变了：

```bash
10月 09 01:58:46 dclab-node2 kubelet[18480]: E1009 01:58:46.613801   18480 pod_workers.go:765] "Error syncing pod, skipping" err="failed to \"CreatePodSandbox\" for \"kube-flannel-ds-5cmpk_kube-system(84df7613-cff5-4dea-9182-339cb2870af5)\" with CreatePodSandboxError: \"Failed to create sandbox for pod \\\"kube-flannel-ds-5cmpk_kube-system(84df7613-cff5-4dea-9182-339cb2870af5)\\\": rpc error: code = Unknown desc = failed pulling image \\\"k8s.gcr.io/pause:3.5\\\": Error response from daemon: Get https://k8s.gcr.io/v2/: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)\"" pod="kube-system/kube-flannel-ds-5cmpk" podUID=84df7613-cff5-4dea-9182-339cb2870af5
```

可以发现是网络问题，熟悉的问题，从国内镜像库下载然后改tag即可，经过该步骤，可以发现dclab-node2已经是ready状态了：

```bash
dclab@dclab-master:~$ sudo kubectl get nodes
NAME           STATUS     ROLES                  AGE   VERSION
dclab-master   Ready      control-plane,master   48m   v1.22.2
dclab-node1    NotReady   <none>                 42m   v1.22.2
dclab-node2    Ready      <none>                 11m   v1.22.2
```

在dclab-node1中执行同样的操作：

```bash
NAME           STATUS   ROLES                  AGE   VERSION
dclab-master   Ready    control-plane,master   51m   v1.22.2
dclab-node1    Ready    <none>                 45m   v1.22.2
dclab-node2    Ready    <none>                 15m   v1.22.2
```



