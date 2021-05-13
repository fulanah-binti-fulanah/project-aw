#!/bin/bash
yl='\e[031;1m'
bl='\e[36;1m'
gl='\e[32;1m'

clear
echo  ""
echo  "             ██╗   ██╗██╗   ██╗███████╗███████╗      " | lolcat
echo  "             ██║   ██║╚██╗ ██╔╝██╔════╝██╔════╝      " | lolcat
echo  "             ██║   ██║ ╚████╔╝ █████╗  █████╗        " | lolcat
echo  "             ██║   ██║  ╚██╔╝  ██╔══╝  ██╔══╝        " | lolcat
echo  "             ╚██████╔╝   ██║   ███████╗███████╗██╗██╗" | lolcat
echo  "              ╚═════╝    ╚═╝   ╚══════╝╚══════╝╚═╝╚═╝" | lolcat
echo  "          ------SCRIPT AUTO INSTALL BY BOKIRTAMPAN------" | lolcat
        
        cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
   	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
echo ""
	echo   "    \e[032;1mCPU Model:\e[0m $cname"
	echo   "    \e[032;1mNumber Of Cores:\e[0m $cores"
	echo   "    \e[032;1mCPU Frequency:\e[0m $freq MHz"
	echo   "    \e[032;1mTotal Amount Of RAM:\e[0m $tram MB"
	echo   "    \e[032;1mTotal Amount Of Swap:\e[0m $swap MB"
	echo   "    \e[032;1mSystem Uptime:\e[0m $up"
echo ""
echo "   -----------------------🅼🅴🅽🆄 🅾🅿🆃🅸🅾🅽🆂------------------------" | lolcat
echo  "   1\e[1;33m)\e[m SSH & OpenVPN Menu"
echo  "   2\e[1;33m)\e[m Panel Wireguard "
echo  "   3\e[1;33m)\e[m Panel L2TP & PPTP Account"
echo  "   4\e[1;33m)\e[m Panel SSTP  Account"
echo  "   5\e[1;33m)\e[m Panel SSR & SS Account"
echo  "   6\e[1;33m)\e[m Panel V2Ray"
echo  "   7\e[1;33m)\e[m Panel VLess"
echo  "   8\e[1;33m)\e[m Panel TRojan"
echo  "  \e[1;32m------------------------------------------------------------\e[m" | lolcat
echo  "                    \e[1;31m\e[1;31m🅰🅻🅻 🆂🆈🆂🆃🅴🅼 🆄🅽🆃🅸🅻🆂 🅼🅴🅽🆄\e[m" | lolcat 
echo  "  \e[1;32m------------------------------------------------------------\e[m" | lolcat
echo  "   9\e[1;33m)\e[m   Add Subdomain Host For VPS"
echo  "   10\e[1;33m)\e[m  Renew Certificate V2RAY"
echo  "   11\e[1;33m)\e[m  Change Port All Account"
echo  "   12\e[1;33m)\e[m  Autobackup Data VPS"
echo  "   13\e[1;33m)\e[m  Backup Data VPS"
echo  "   14\e[1;33m)\e[m  Restore Data VPS"
echo  "   15\e[1;33m)\e[m  Webmin Menu"
echo  "   16\e[1;33m)\e[m  Limit Bandwith Speed Server"
echo  "   17\e[1;33m)\e[m  Check Usage of VPS Ram" 
echo  "   18\e[1;33m)\e[m  Reboot VPS"
echo  "   19\e[1;33m)\e[m  Speedtest VPS"
echo  "   20\e[1;33m)\e[m  Information Display System" 
echo  "   21\e[1;33m)\e[m  Info Script Auto Install"
echo  "   22\e[1;33m)\e[m  Install BBR"
echo  "  \e[1;32m------------------------------------------------------------\e[m" | lolcat
echo  "   x)   Exit" | lolcat
echo  "  \e[1;32m------------------------------------------------------------\e[m" | lolcat
echo  ""
read -p "     Select From Options [1-8 or x] :  " menu
echo  ""
case $menu in
1)
ssh
;;
2)
wgr
;;
3)
l2tp
;;
4)
sstpp
;;
5)
ssssr
;;
6)
v2raay
;;
7)
vleess
;;
8)
trojaan
;;
9)
add-host
;;
10)
certv2ray
;;
11)
change
;;
12)
autobackup
;;
13)
backup
;;
14)
restore
;;
15)
wbmn
;;
16)
limit-speed
;;
17)
ram
;;
18)
reboot
;;
19)
speedtest
;;
20)
info
;;
21)
about
;;
22)
bbr
;;
x)
exit
;;
*)
echo "Please enter an correct number"
;;
esac

