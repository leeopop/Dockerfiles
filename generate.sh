#!/bin/bash

for target in debian dpdk node
do
    cat template/Dockerfile.pre > $target/Dockerfile
    cat $target/Dockerfile.template >> $target/Dockerfile
    cat template/Dockerfile.post > $target/Dockerfile
done
