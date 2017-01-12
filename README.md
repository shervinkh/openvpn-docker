# OpenVPN Docker
An OpenVPN Docker
- Run with `docker run -dt --name openvpn -p 1194:1194 -v /home/user/openvpn/vpns/:/etc/openvpn/server/ -v /home/user/openvpn/log/:/var/log --cap-add=NET_ADMIN -e IPV4_PRIVATE_SUBNET="10.8.0.0/16" -e IPV6_PRIVATE_SUBNET="fd80::/48" openvpn`
- Then supervisor interface is at port `9001`.

