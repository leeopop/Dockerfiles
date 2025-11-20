#!/bin/bash
source ./setenv.sh
SKIP_LIST=("scripts" "template")

# Function to process Dockerfile template and add rename command after ADD instructions
# Usage: process_dockerfile_template <input_file> <prefix_number>
process_dockerfile_template() {
    local input_file="$1"
    local prefix="$2"
    
    while IFS= read -r line; do
        echo "$line"
        # If line matches "ADD */*.sh /install-scripts" pattern, add RUN command to rename
        if [[ "$line" =~ ^ADD[[:space:]].*\/\*\.sh[[:space:]]\/install-scripts ]]; then
            echo "# Rename scripts without numeric prefix"
            echo "RUN cd /install-scripts && for f in *.sh; do if [[ ! \"\$f\" =~ ^[0-9][0-9]_ ]]; then mv \"\$f\" \"${prefix}_\$f\"; fi; done"
        fi
    done < "$input_file"
}

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
        INCLUDE_FILES=()
        for item in "${INCLUDE_LIST[@]}"; do
            INCLUDE_FILES+=("${item}/.includes")
        done
        # Collect new includes and append original list at the end
        NEW_INCLUDES=`(cat "${INCLUDE_FILES[@]}" 2>/dev/null || true) | sort -u | tr '\n' ' '`
        NEW_INCLUDE_LIST=`((printf '%s\n' ${NEW_INCLUDES}); (printf '%s\n' "${INCLUDE_LIST[@]}")) | awk '!seen[$0]++' | tr '\n' ' '`
        NEW_INCLUDE_LIST=(${NEW_INCLUDE_LIST})
        # Compare arrays by converting to strings
        OLD_STR=$(printf '%s ' "${INCLUDE_LIST[@]}")
        NEW_STR=$(printf '%s ' "${NEW_INCLUDE_LIST[@]}")
        if [[ "${OLD_STR}" == "${NEW_STR}" ]];
        then
            # echo "  No more updates"
            echo "  Includes: ${INCLUDE_LIST[@]}"
            break
        fi
        INCLUDE_LIST=("${NEW_INCLUDE_LIST[@]}")
    done
    cat template/Dockerfile.pre > ${target}/Dockerfile
    
    # Process Dockerfile templates and add numbered prefix to install scripts
    prefix_counter=0
    for include in "${INCLUDE_LIST[@]}"; do
        if [[ -f "${include}/Dockerfile.template" ]]; then
            prefix=$(printf "%02d" $prefix_counter)
            process_dockerfile_template "${include}/Dockerfile.template" "$prefix" >> ${target}/Dockerfile
            ((prefix_counter++))
        fi
    done
    
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
