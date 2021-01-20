#!/bin/sh
random() {
	tr </dev/urandom -dc A-Za-z0-9 | head -c5
	echo
}

array=(1 2 3 4 5 6 7 8 9 0 a b c d e f)

install_3proxy() {
    echo "installing 3proxy"
    URL="https://github.com/z3APA3A/3proxy/archive/3proxy-0.8.6.tar.gz"
    wget -qO- $URL | bsdtar -xvf-
    cd 3proxy-3proxy-0.8.6
    make -f Makefile.Linux
    mkdir -p /usr/local/etc/3proxy/{bin,logs,stat}
    cp src/3proxy /usr/local/etc/3proxy/bin/
    cp ./scripts/rc.d/proxy.sh /etc/init.d/3proxy
    chmod +x /etc/init.d/3proxy
    chkconfig 3proxy on
    cd $WORKDIR
}

gen_3proxy() {
    cat <<EOF
daemon
maxconn 10000
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
stacksize 262144
flush
users russthomas:CL:russsumityt
auth strong
allow russthomas

$(awk -F "/" '{print "proxy -p"$2" -a -n -i"$3" -e"$3 "\n" }' ${WORKDATA})
EOF
}

gen_proxy_file_for_user() {
    cat >proxy.txt <<EOF

}


gen_iptables() {
    cat <<EOF
    $(awk -F "/" '{print "iptables -I INPUT -p tcp --dport " $2 "  -m state --state NEW -j ACCEPT"}' ${WORKDATA}) 
EOF
}


echo "installing apps"
yum -y install gcc net-tools bsdtar zip >/dev/null

install_3proxy

echo "working folder = /home/proxy-installer"
WORKDIR="/home/proxy-installer"
mkdir $WORKDIR && cd $_

IP4=$(curl -4 -s ifconfig.co)

echo "Internal ip = ${IP4}"

echo "How many proxy do you want to create? Example 500"
read COUNT


FIRST_PORT=3100
LAST_PORT=$(($FIRST_PORT + $COUNT))
gen_iptables >$WORKDIR/boot_iptables.sh
chmod +x boot_*.sh /etc/rc.local

gen_3proxy >/usr/local/etc/3proxy/3proxy.cfg

cat >>/etc/rc.local <<EOF
bash ${WORKDIR}/boot_iptables.sh

ulimit -n 65536
service 3proxy start
EOF

bash /etc/rc.local

gen_proxy_file_for_user


