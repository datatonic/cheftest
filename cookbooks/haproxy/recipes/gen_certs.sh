#!/bin/bash

#openssl req -new -key /etc/ssl/cheftest.key  -out /etc/ssl/cheftest.csr
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=CA/L=Roseville/O=CloudCompute/CN=CloudComputeGuru" -keyout /etc/ssl/cheftest.key  -out /etc/ssl/cheftest.cert
openssl req -new -key /etc/ssl/cheftest.key  -out /etc/ssl/cheftest.csr -subj "/C=US/ST=CA/L=Roseville/O=CloudCompute/CN=CloudComputeGuru"
openssl x509 -req -days 365 -in  /etc/ssl/cheftest.csr  -signkey   /etc/ssl/cheftest.key  -out /etc/ssl/cheftest.crt
cat /etc/ssl/cheftest.key  /etc/ssl/cheftest.crt > /etc/ssl/private/cheftest.pem
