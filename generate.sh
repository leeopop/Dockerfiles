#!/bin/bash
source ./setenv.sh
SKIP_LIST=("scripts" "template")

# Reset compose file
cat template/docker-compose.yaml.pre > docker-compose.yaml

for target in `ls -d */`
do
    target=${target%%/}
    # Check if target is in the skip list
    `echo ${SKIP_LIST[@]} | grep -w -q ${target}`
    if [[ $? == 0 ]]; then
        echo "Skip ${target}"
        continue
    else
        echo "Generating template for ${target}..."
    fi
    INCLUDE_LIST=(${target})
    while :
    do
        # echo "  Include list for ${target}: ${INCLUDE_LIST[@]}"
        INCLUDE_FILES=( "${INCLUDE_LIST[@]/%/\/.includes}" )
        NEW_INCLUDE_LIST=`((echo ${INCLUDE_LIST} | tr ' ' '\n'); (cat ${INCLUDE_FILES[@]} 2>/dev/null || true)) | sort -u | tr '\n' ' '`
        NEW_INCLUDE_LIST=(${NEW_INCLUDE_LIST})
        if [[ "${NEW_INCLUDE_LIST[@]}" == "${INCLUDE_LIST[@]}" ]];
        then
            # echo "  No more updates"
            echo "  Includes: ${INCLUDE_LIST[@]}"
            break
        fi
        INCLUDE_LIST=(${NEW_INCLUDE_LIST[@]})
    done
    cat template/Dockerfile.pre > ${target}/Dockerfile
    INCLUDE_TEMPLATES=( "${INCLUDE_LIST[@]/%//Dockerfile.template}" )
    (cat ${INCLUDE_TEMPLATES[@]} 2>/dev/null || true) >> ${target}/Dockerfile
    cat template/Dockerfile.post >> ${target}/Dockerfile

    # Install docker-compose template
    if [[ -f "${target}/.port" ]] ; then
        TARGET_PORT=`cat ${target}/.port | tr -d ' \n'`
        cat template/docker-compose.yaml.template | sed "s/TARGET_PORT/${TARGET_PORT}/g" | sed "s/TARGET_NAME/${target}/g" >> docker-compose.yaml
    fi
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
