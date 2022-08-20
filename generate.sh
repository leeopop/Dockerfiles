#!/bin/bash
source ./setenv.sh
for target in debian dpdk node rust
do
    cat template/Dockerfile.pre > $target/Dockerfile
    if [ -f "$target/Dockerfile.template" ] ; then
        cat $target/Dockerfile.template >> $target/Dockerfile
    fi
    cat template/Dockerfile.post >> $target/Dockerfile
done
