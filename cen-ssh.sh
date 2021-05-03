#!/bin/bash
#
# ==================================================

# initializing var
export CENTOS_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=red-flat.my.id
organizationalunit=red-flat.my.id
commonname=red-flat.my.id
email=admin@red-flat.my.id

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/bokiroke1/project-aw/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local


# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install essential package
yum -y install net-snmp net-snmp-utils
yum -y install iftop 
yum -y install htop
yum -y groupinstall 'Development Tools'
yum -y install cmake
yum -y install wget
yum -y install unzip
yum -y install git
yum -y install make
yum -y install gcc
yum -y install gcc-c++
yum -y install screen
yum -y install nano

# install neofetch centos
if [[ $ver == '7' ]]; then
git clone https://github.com/dylanaraps/neofetch
cd neofetch
make install
make PREFIX=/usr/local install
make PREFIX=/boot/home/config/non-packaged install
make -i install
cd
rm -rf neofetch
elif [[ $ver == '8' ]]; then
yum -y install neofetch
fi
cd
echo "clear" >> .bash_profile
echo "neofetch" >> .bash_profile
echo "echo by Ceu Edoh Project" >> .bash_profile

# install webserver
yum -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/bokiroke1/project-aw/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/bokiroke1/project-aw/main/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/bokiroke1/project-aw/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
yum -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
yum -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/bokiroke1/project-aw/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
yum -y install vnstat
/etc/init.d/vnstat restart
yum -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# install stunnel
yum install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 443
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#OpenVPN
wget https://raw.githubusercontent.com/bokiroke1/project-aw/main/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
yum -y install fail2ban

# install webmin
cd
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty
yum install webmin -y
sed -i -e 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
chkconfig webmin on

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/bokiroke1/project-aw/main/add-host.sh"
wget -O about "https://raw.githubusercontent.com/bokiroke1/project-aw/main/about.sh"
wget -O menu "https://raw.githubusercontent.com/bokiroke1/project-aw/main/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/bokiroke1/project-aw/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/bokiroke1/project-aw/main/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/bokiroke1/project-aw/main/hapus.sh"
wget -O member "https://raw.githubusercontent.com/bokiroke1/project-aw/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/bokiroke1/project-aw/main/delete.sh"
wget -O cek "https://raw.githubusercontent.com/bokiroke1/project-aw/main/cek.sh"
wget -O restart "https://raw.githubusercontent.com/bokiroke1/project-aw/main/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/bokiroke1/project-aw/main/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/bokiroke1/project-aw/main/info.sh"
wget -O ram "https://raw.githubusercontent.com/bokiroke1/project-aw/main/ram.sh"
wget -O renew "https://raw.githubusercontent.com/bokiroke1/project-aw/main/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/bokiroke1/project-aw/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/bokiroke1/project-aw/main/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/bokiroke1/project-aw/main/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/bokiroke1/project-aw/main/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/bokiroke1/project-aw/main/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-ssl.sh"
wget -O port-wg "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-tr.sh"
wget -O port-sstp "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-sstp.sh"
wget -O port-squid "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-squid.sh"
wget -O port-ws "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-ws.sh"
wget -O port-vless "https://raw.githubusercontent.com/bokiroke1/project-aw/main/port-vless.sh"
wget -O wbmn "https://raw.githubusercontent.com/bokiroke1/project-aw/main/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/bokiroke1/project-aw/main/xp.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/bokiroke1/project-aw/main/kernel-update.sh"
chmod +x add-host
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x clear-log
chmod +x change-port
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-wg
chmod +x port-sstp
chmod +x port-tr
chmod +x port-squid
chmod +x port-ws
chmod +x port-vless
chmod +x wbmn
chmod +x xp
chmod +x kernel-updt
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
# remove unnecessary files
cd
yum autoclean -y
yum -y remove --purge unscd
yum -y remove samba*;
yum -y remove apache2*;
yum -y remove bind9*;
yum -y remove sendmail*
yum autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finihsing
clear