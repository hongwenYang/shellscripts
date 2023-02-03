#!/bin/bash
DATE=$(date +%d/%b/%Y:%H:%M)
ABNORMAL_IP=$(tail -n5000 access.log |grep $DATE |awk '{a[$1]++}END{for(i in a)if(a[i]>100)print i}')
for IP in $ABNORMAL_IP;do
    if [ $(iptables -vnl |grep -c "$IP") -eq 0 ];then
        iptables -I INPUT -s $IP -j DROP
    fi
done