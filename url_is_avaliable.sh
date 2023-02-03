#!/bin/bash
check_url(){
    if ! which curl &>/dev/null;then
        echo "curl command not found,Please install process package."
        exit 1
    fi
    HTTP_CODE=$(curl -o /dev/null --connect-timeout 3 -s -w "%{http_code}" $1)
    if [ $HTTP_CODE -ne 200 ];then
        echo "Warning: $1 Access failure!"
    fi
}
check_url $1