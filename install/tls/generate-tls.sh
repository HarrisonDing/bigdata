#!/bin/bash
# Generate Root CA
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"

# Generate API Server Keypair
openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

# Move to work dir
mkdir -p /etc/kubernetes/ssl
mv -t /etc/kubernetes/ssl/ ca.pem apiserver.pem apiserver-key.pem

# Set Permissions
chmod 600 /etc/kubernetes/ssl/apiserver-key.pem
chown root:root /etc/kubernetes/ssl/apiserver-key.pem
