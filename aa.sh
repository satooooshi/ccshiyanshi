
# 删除 Rancher 并清理

# 删除容器
docker rm -f $(sudo docker ps -aq);
# 删除卷
docker volume rm $(sudo docker volume ls -q);
# 卸载 kubelet 挂载目录
for m in $(sudo tac /proc/mounts | sudo awk '{print $2}' | sudo grep /var/lib/kubelet);do
sudo umount $m||true
done
# 卸载 rancher 挂载目录
for m in $(sudo tac /proc/mounts | sudo awk '{print $2}' | sudo grep /var/lib/rancher);do
sudo umount $m||true
done
# 删除相关目录
rm -rf /etc/cni \
       /etc/kubernetes \
       /opt/cni \
       /opt/rke \
       /run/secrets/kubernetes.io \
       /run/calico \
       /run/flannel \
       /var/lib/calico \
       /var/lib/etcd \
       /var/lib/cni \
       /var/lib/kubelet \
       /var/lib/rancher \
       /var/log/containers \
       /var/log/pods \
       /var/run/calico

rm -f /var/lib/containerd/io.containerd.metadata.v1.bolt/meta.db
sudo systemctl restart containerd
sudo systemctl restart docker

# clean up docker containers and volumes
# docker rm -vf $(docker ps -aq)
# clean up images 
# docker rmi -f $(docker images -aq)

# chmod 774 aa.sh to make this file executable
