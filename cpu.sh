#!/bin/bash
DATE=$(date +%F" "%H:%M)
IP=$(hostname -I |awk '{print $1}')
MAIL="yanghongwen@islide.cc"
cpu_monitor(){
    if ! which vmstat &>/dev/null;then
        echo "vmstat command not found,Please install process package."
        exit 1
    fi
    US=$(vmstat |awk 'NR==3{print $13}')
    SY=$(vmstat |awk 'NR==3{print $14}')
    IDLE=$(vmstat |awk 'NR==3{print $15}')
    WAIT=$(vmstat |awk 'NR==3{print $16}')
    USE=$(($US+$SY))
    if [ $USE -lt 50 ];then
        echo "
        Date: $DATE
        Host: $IP
        Problem: CPU is utilization $USE
        " | mail -s "CPU Monitor" $MAIL
    fi
}
memory_monitor(){
    TOTAL=$(free -m |awk '/Mem/{print $2}')
    USE=$(free -m |awk '/Mem/{print $3}')
    FREE=$(free -m |awk '/Mem/{print $4}')
    # 内存小于1G发送报警邮件
    if [ $FREE -lt 1024 ];then
        echo "
        Date: $DATE
        Host: $IP
        Problem: Total=$TOTAL,Use=$USE,Free=$FREE
        " | mail -s "Memory Monitor" $MAIL
    fi
}
disk_monitor(){
    TOTAL=$(fdisk -l |awk -F '[: ]+' 'BEGIN{OFS="="}/^Disk \/dev/{printf "%s=%sG,",$2,$3}')
    PART_USE=$(df -h |awk 'BEGIN{OFS="="}/^\/dev/{print $1,int($5),$6}')
    for i in $PART_USE;do
        PART=$(echo $i |cut -d"=" -f1)
        USE=$(echo $i |cut -d"=" -f2)
        MOUNT=$(echo $i |cut -d"=" -f3)
        if [ $USE -lt 80 ];then
            echo "
            Date: $DATE
            Host: $IP
            Total: $TOTAL
            Problem: $PART=$USE($MOUNT)
            " | mail -s "Disk Monitor" $MAIL
        fi
    done
}
cpu_monitor
memory_monitor
disk_monitor