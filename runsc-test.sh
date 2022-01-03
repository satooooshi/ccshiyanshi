for i in $(seq 1 $1) ; do
    sudo docker run --runtime=runsc --name gvisor-test hello-world > /dev/null 2>&1
    sudo docker rm gvisor-test > /dev/null 2>&1
done
