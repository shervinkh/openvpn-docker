#!/bin/bash

mkdir -p /var/log/supervisor

for file in "/etc/openvpn/server"/*.conf; do
filename=$(basename $file)
name=${filename%.*}
cat > /etc/supervisor.d/$name.ini <<EOF
[program:$name]
command=/usr/bin/openvpn --config /etc/openvpn/server/$name.conf
redirect_stderr=true
stdout_logfile=/var/log/supervisor/$name.log
EOF
done

mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

if [ ${NAT_DEVICE} ]; then
if [ ${IPV4_PRIVATE_SUBNET} ]; then
iptables -t nat -C POSTROUTING -s ${IPV4_PRIVATE_SUBNET} -o ${NAT_DEVICE} -j MASQUERADE || iptables -t nat -A POSTROUTING -s ${IPV4_PRIVATE_SUBNET} -o ${NAT_DEVICE} -j MASQUERADE
fi

if [ ${IPV6_PRIVATE_SUBNET} ] && [ ${IPV6_NAT_TO} ]; then
ip6tables -t nat -C POSTROUTING -o ${NAT_DEVICE} -s ${IPV6_PRIVATE_SUBNET} -j SNAT --to-source ${IPV6_NAT_TO} || ip6tables -t nat -A POSTROUTING -o ${NAT_DEVICE} -s ${IPV6_PRIVATE_SUBNET} -j SNAT --to-source ${IPV6_NAT_TO}
fi

sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_forward=1
fi

echo "Initialized!"

