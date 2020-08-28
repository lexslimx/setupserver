apt update
apt upgrade -yuf
apt install -y --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev \
                                       asciidoc xmlto libev-dev libudns-dev automake libmbedtls-dev \
                                       libsodium-dev git python-m2crypto libc-ares-dev
                                       cd /opt
git clone https://github.com/shadowsocks/shadowsocks-libev.git

apt-get --yes --force-yes install -y automake
apt-get --yes --force-yes install build-essential
mkdir shadowsocks-libev/build-area
cp shadowsocks-libev/scripts/build_deb.sh shadowsocks-libev/build-area/build_deb.sh
bash ./shadowsocks-libev/build-area/build_deb.sh

#Create a new system user for Shadowsocks:
adduser --system --no-create-home --group shadowsocks

#Create a new directory for the configuration file:
mkdir -m 755 /etc/shadowsocks

#copy local conf file
cp shadowsocks.json /etc/shadowsocks/shadowsocks.json

#Optimize ShadowsocksPermalink
cp local.conf /etc/sysctl.d/local.conf

#Apply optimizations:
sysctl --system

#copy systemd file
cp shadowsocks.service /etc/systemd/system/shadowsocks.service

#Enable and start shadowsocks.service:
systemctl daemon-reload
systemctl enable shadowsocks
systemctl start shadowsocks

#iptables
iptables -4 -A INPUT -p tcp --dport 443 -m comment --comment "Shadowsocks server listen port" -j ACCEPT

#ufw
ufw allow proto tcp to 0.0.0.0/0 port 443 comment "Shadowsocks server listen port"

#firewall
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port protocol="tcp" port="8388" accept'
firewall-cmd --reload