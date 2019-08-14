#!/bin/bash

#DIR根据项目不一样而修改，n2n_ip根据服务器分配ip不同而修改
DIR=/usr/scanserver
n2n_ip_FILE=$DIR/cf.d/n2n_ip
n2n_edge_FILE=$DIR/bin/edge


echo "-------------------------------n2n_edge.sh" >> /home/pi/n2n_log.txt
date >> /home/pi/n2n_log.txt #

NETWORK_OK=0
PING_DST="114.114.114.114"
#启动前必须可以连接外网
echo "n2n edge start network check..." >> /home/pi/n2n_log.txt
while [ $NETWORK_OK -ne 1 ]
do
    network_status=`ping $PING_DST -c 1 -W 5 | grep ttl | wc -l`
    if [ "$network_status"x = "1"x ]; then
        NETWORK_OK=1
        echo "ping $PING_DST -c 1 -W 5 | grep ttl | wc -l , network ok" >> /home/pi/n2n_log.txt
    else
        echo "ping $PING_DST -c 1 -W 5 | grep ttl | wc -l , network fail" >> /home/pi/n2n_log.txt
        sleep 2
        continue
    fi
done

#如果n2n edge未启动，则开启运行
echo "n2n edge run..." >> /home/pi/n2n_log.txt
N=a`ps -C edge | grep -v CMD`b
if [ "${N}" != "ab" ] ; then
    echo "n2n edge exists." >> /home/pi/n2n_log.txt
else
    if [ ! -f $n2n_ip_FILE ]; then 
        echo "n2n edge file $n2n_ip_FILE cannot find!" >> /home/pi/n2n_log.txt
    else
        echo "n2n edge read $n2n_ip_FILE file." >> /home/pi/n2n_log.txt
        Linenum=0
        cat $n2n_ip_FILE | while read myline
        do
            Linenum=$(($Linenum+1))
            if [ $Linenum -eq 1 ]; then
                echo "n2n local ip:"$myline >> /home/pi/n2n_log.txt
                $n2n_edge_FILE -d n2n0 -c respvpn -k teligen@x101 -a $myline -l 183.63.70.122:11001 >/dev/null &
            fi
        done
    fi
fi

NDS_OK=0
TIM=1
#n2n edge启动完成后，如果当前系统使用的是无线网络，可能导致dns记录清空，无法解析域名，所以检查并手动添加dns
echo "n2n edge start dns check..." >> /home/pi/n2n_log.txt
while [[ $NDS_OK -ne 1  &&  $TIM -le 10 ]]
do
    echo $TIM >>  /home/pi/n2n_log.txt
    cat /etc/resolv.conf >> /home/pi/n2n_log.txt
    if ifconfig|grep n2n0 >> /home/pi/n2n_log.txt 2>&1
    then	
        echo "ifconfig n2n0 ok" >> /home/pi/n2n_log.txt
        sleep 5
        NDS_OK=1
        if cat /etc/resolv.conf | grep nameserver >> /home/pi/n2n_log.txt 2>&1
        then
            echo "nameserver exists." >> /home/pi/n2n_log.txt
        else
            echo "add nameserver 114.114.114.114" >> /home/pi/n2n_log.txt
            echo "nameserver 114.114.114.114" >> /etc/resolv.conf
        fi
    else
        echo "ifconfig n2n0 false" >> /home/pi/n2n_log.txt
    fi
    TIM=$(($TIM+1))
    sleep 5
done








