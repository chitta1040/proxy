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
    seq $FIRST_PORT $COUNT | while read port; do
         echo "proxy -6 -n -a -p$port -i $IP4 -e $(gen64 $IP6)"
    done
}

echo "Enter your Ipv4"
read IP4

echo "How many proxy do you want to create? Example 500"
read COUNT

echo "Please Enter your ipv6"
read IP6


FIRST_PORT=3100
LAST_PORT=$(($FIRST_PORT + $COUNT))



gen_data


