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

if [ ${IPV4_PRIVATE_SUBNET} ]; then
iptables -t nat -C POSTROUTING -s ${IPV4_PRIVATE_SUBNET} -o eth0 -j MASQUERADE || iptables -t nat -A POSTROUTING -s ${IPV4_PRIVATE_SUBNET} -o eth0 -j MASQUERADE
fi

if [ ${IPV6_PRIVATE_SUBNET} ] then
my_ipv6=$(ip -o -6 addr show eth0 | sed -e 's/^.*inet6 \([^ ]\+\).*/\1/' | head -n 1 | cut -d/ -f 1)
ip6tables -t nat -C POSTROUTING -o eth0 -s ${IPV6_PRIVATE_SUBNET} -j SNAT --to-source $my_ipv6 || ip6tables -t nat -A POSTROUTING -o eth0 -s ${IPV6_PRIVATE_SUBNET} -j SNAT --to-source $my_ipv6
fi

echo "Initialized!"

