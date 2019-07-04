#!/bin/bash

set -e

CN=${1:-"openshift-inermediate-ca"}
#DN=${DN:-"/C=RU/ST=Moscow/L=Moscow/O=Red Hat B.V. CIS/OU=Solution Architecture/mail=cis-sa@redhat.ru/CN=$CN"}
DN_PREFIX=${DN_PREFIX:-"/C=RU/ST=Moscow/L=Moscow/O=Red Hat B.V. CIS/OU=Solution Architecture/mail=cis-sa@redhat.ru"}
DN=${DN:-"$DN_PREFIX/CN=$CN"}
CA=${CA:-$ROOT_CA}
KEY_TYPE=${KEY_TYPE:-"rsa:2048"}

CUR_DIR=${ASSETS_PREFIX:-$(pwd)}

ASSETS=${CUR_DIR}/assets
CA_ASSETS=$ASSETS/ca

if [ -r "${ASSETS}/${CN}.key.pem" ] ; then
    #echo \
    openssl req \
	-config ${CA_ASSETS}/$CA/openssl-${CA}.cnf \
	-new \
	-nodes \
	-key ${ASSETS}/"${CN}".key.pem \
	-out ${CA_ASSETS}/"${CN}".csr.pem \
	-subj "${DN}"
    echo "OLD KEY FOUND: just renew CSR"
else 
    #echo \
    openssl req \
	-config ${CA_ASSETS}/$CA/openssl-${CA}.cnf \
	-new \
	-nodes \
	-out ${CA_ASSETS}/"${CN}".csr.pem \
	-newkey ${KEY_TYPE} \
	-keyout ${ASSETS}/"${CN}".key.pem \
	-subj "${DN}"
fi

openssl req -text -noout -in ${CA_ASSETS}/"${CN}".csr.pem
