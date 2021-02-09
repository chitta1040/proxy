#!/bin/sh
random() {
	tr </dev/urandom -dc A-Za-z0-9 | head -c5
	echo
}

array=(1 2 3 4 5 6 7 8 9 0 a b c d e f)

gen64() {
	ip64() {
		echo "${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}"
	}
	echo "$1:$(ip64):$(ip64):$(ip64):$(ip64)"
}


gen_data() {
    pfile=proxy.txt
    echo "auth iponly" >> $pfile
    echo "allow * $IP4" >> $pfile
    
    seq $FIRST_PORT $LAST_PORT | while read port; do
         IP66=$(gen64 $IP6)
	 
         echo "proxy -6 -n -a -p$port -i$IP4 -e$IP66" >> $pfile
	 netsh interface ipv6 add address "Ethernet" $IP66
    
    done
   
}

echo "working folder = C:\Users\Administrator\Desktop\proxy"
WORKDIR="C:\Users\Administrator\Desktop\proxy"
WORKDATA="${WORKDIR}/data.txt"
mkdir $WORKDIR && cd $_


IP4=$(curl -4 -s ifconfig.co)
IP6=$(curl -6 -s ifconfig.co | cut -f1-4 -d':')

echo "Internal ip = ${IP4}. Exteranl sub for ip6 = ${IP6}"

echo "How many proxy do you want to create? Example 500"
read COUNT


FIRST_PORT=3100
LAST_PORT=$(($FIRST_PORT + $COUNT))



gen_data



