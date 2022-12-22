#!/bin/sh

sudo nmap -sS -T4 -A -p- $1 > tcp_$1.txt
sudo nmap -sU -vv $1 > udp_$1.txt

if grep -F "80/tcp"  tcp_$1.txt
    then
    echo "HTTP found running!"
    echo "Searching for directories"
    gobuster dir -u http://$1/ -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt > gb_dir_$1.txt
    echo "Searching for vhosts"
    gobuster vhost -u http://$1/ -w /usr/share/wordlists/vhosts.txt |grep -v 302 > gb_vhosts_$1.txt
    echo "Looking for wordpress"
    # if grep -F "" tcp_$1.txt
    #     then
    #     echo "Found Wordpress. running scans..."
    #     echo "Enumerating users..."
    #     wpscan -e u --url http://$1/ --force > wp_users.txt
    #     echo "scanning wordpress"


else
    echo "No HTTP server detected"
fi

if grep -F "3306/tcp open"
    then
    echo "Found MySQL running"
    echo "Enumerating MySQL"
    nmap -sV -p 3306 --script mysql-audit,mysql-databases,mysql-dump-hashes,mysql-empty-password,mysql-enum,mysql-info,mysql-query,mysql-users,mysql-variables,mysql-vuln-cve2012-2122 $1 > mysql_$1.txt
else
    echo "No MySQL found running"
    
fi
