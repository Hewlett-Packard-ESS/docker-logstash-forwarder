#!/bin/bash
mkdir -p /storage/ssl

if [ "$logstash_cn" == "" ]; then
  logstash_cn=logstash.local
fi

echo "$logstash_ip $logstash_cn" >> /etc/hosts

if [ "$logstash_port" == "" ]; then
  logstash_port=5043
fi

if [ ! -f /storage/ssl/logstash-forwarder.key ] || [ ! -f /storage/ssl/logstash-forwarder.crt ]; then
  echo Please wait, generating unique SSL certificates...
  cd /storage/ssl
  openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt -subj /CN=$logstash_cn -days 3650 >/dev/null 2>&1
  echo Certificates generated.
fi

if [ ! -f /storage/config.json ]; then
  echo Creating config from template.
  cp /tmp/config.json /storage/config.json
  sed -i s/%logstash%/$logstash_cn:$logstash_port/g /storage/config.json
fi 

echo Private Key:
cat /storage/ssl/logstash-forwarder.key
echo

echo Logstash-Forwarder Certificate:
cat /storage/ssl/logstash-forwarder.crt

echo Logstash Certificate CN: $logstash_cn
