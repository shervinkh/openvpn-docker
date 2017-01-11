# OpenVPN Docker
An OpenVPN Docker
- Run with `docker run -dt --name openvpn -p 1194:1194 -v /home/user/openvpn/vpns/:/etc/openvpn/server/ -v /home/user/openvpn/log/:/var/log --cap-add=NET_ADMIN -e NAT_DEVICE=eth0 -e IPV4_PRIVATE_SUBNET="10.8.0.0/16" -e IPV6_PRIVATE_SUBNET="fd80::/48" -e IPV6_NAT_TO="2607:f8b0:4006:804::200e" --net=host openvpn`
- Then supervisor interface is at port `9001`.

