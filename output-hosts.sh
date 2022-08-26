#!/bin/bash

ls ./$1-servers &>/dev/null && rm -f ./$1-servers
tmp=$(mktemp)
trap "rm -rf $tmp" EXIT

ansible-inventory --list -i $1.vmware.yml > $tmp
arr=($(grep -w -B1 ansible_host tmp | tr -d ",\"\-{" | sed -e '/^$/d' -e 's/ //g' -e 's/:$//g' -e 's/:/=/g'))

count=1
for i in ${arr[@]} ; do
    if [ $((${count}%2)) -eq 1 ] ; then
        echo ${arr[$count-1]} ${arr[$(($count))]} >> ./$1-servers
    fi
    ((count=count+1))
done

exit 0
