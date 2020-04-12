#!/bin/bash

CF_NGINX_CONFIG="/usr/local/nginx/conf/cloudflare-allow.conf"

CF_URL_IP4="https://www.cloudflare.com/ips-v4"

CF_TEMP_IP4="/tmp/cloudflare-ips-v4.txt"

if [ -f /usr/bin/curl ];
then
    curl --silent --output $CF_TEMP_IP4 $CF_URL_IP4
elif [ -f /usr/bin/wget ];
then
    wget --quiet --output-document=$CF_TEMP_IP4 --no-check-certificate $CF_URL_IP4
else
    echo "Unable to download CloudFlare files."
    exit 1
fi

if [ -s $CF_TEMP_IP4 ];
then
    echo "# IPv4 update $(date +%Y-%m-%d/%T)" > $CF_NGINX_CONFIG
    awk '{ print "allow " $0 ";" }' $CF_TEMP_IP4 >> $CF_NGINX_CONFIG
    echo "" >> $CF_NGINX_CONFIG
fi

rm $CF_TEMP_IP4

/usr/local/nginx/sbin/nginx -s reload
