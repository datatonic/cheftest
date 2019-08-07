#!/bin/bash

# Generate a unique private key (KEY)
openssl genrsa -out /etc/ssl/cheftest.key 4096

# Generating a Certificate Signing Request (CSR)
openssl req -new -key /etc/ssl/cheftest.key -subj "/C=US/ST=CA/L=Roseville/O=CloudCompute/CN=CloudComputeGuru" -out /etc/ssl/cheftest.csr

# Creating a Self-Signed Certificate (CRT)
openssl x509 -req -days 365 -in /etc/ssl/cheftest.csr -signkey /etc/ssl/cheftest.key -out /etc/ssl/cheftest.crt

# Append KEY and CRT to cheftest.pem
cat /etc/ssl/cheftest.key /etc/ssl/cheftest.crt >> /etc/ssl/private/cheftest.pem

