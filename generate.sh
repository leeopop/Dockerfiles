#!/bin/bash
source ./setenv.sh
for target in debian dpdk node rust python
do
    cat template/Dockerfile.pre > $target/Dockerfile
    if [[ -f "$target/Dockerfile.template" ]] ; then
        cat $target/Dockerfile.template >> $target/Dockerfile
    fi
    cat template/Dockerfile.post >> $target/Dockerfile
done

if [[ -d ".ssh_key" ]] ; then
    echo "Using existing ssh key"
else
    mkdir -p ".ssh_key"
    for target in ed25519 ecdsa rsa
    do
        ssh-keygen -t ${target} -f .ssh_key/ssh_host_${target}_key -P ""
    done
fi
