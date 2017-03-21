FROM shervinkh/my-archlinux
MAINTAINER "Shervin Khastoo" <shervinkh145@gmail.com>

COPY scripts /scripts/
RUN /update.sh && \
    pacman -S --noconfirm binutils patch autoconf automake libtool gcc pkg-config pkcs11-helper systemd make fakeroot && \
    /scripts/aur_install.sh openvpn-xor-patched && \
    pacman -Rs --noconfirm binutils patch autoconf automake libtool gcc pkg-config make fakeroot && \
    mkdir -p /keys /etc/openvpn/server && \
    /cleanup.sh

EXPOSE 9001

