#!/bin/sh

generate_cert() {
    node_name=$1

    openssl genrsa -out certs/$node_name.key 2048
    chmod 400 certs/$node_name.key

    openssl req \
        -new \
        -config $node_name.cnf \
        -key certs/$node_name.key \
        -out $node_name.csr \
        -batch
    
    openssl ca \
        -config ca.cnf \
        -keyfile my-safe-directory/ca.key \
        -cert certs/ca.crt \
        -policy signing_policy \
        -extensions signing_node_req \
        -out certs/$node_name.crt \
        -outdir certs/ \
        -in $node_name.csr \
        -batch

    openssl x509 -in certs/$node_name.crt -text | grep "X509v3 Subject Alternative Name" -A 1
}

nodes=(crdb-0 crdb-1 crdb-2)

for node in "${nodes[@]}"
do
  generate_cert $node
done