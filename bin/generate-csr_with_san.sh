#!/bin/bash

set -e

CN=${1:-"openshift-default-router"}
#DN=${DN:-"/C=RU/ST=Moscow/L=Moscow/O=Red Hat B.V. CIS/OU=Solution Architecture/mail=cis-sa@redhat.ru/CN=$CN"}
DN_PREFIX=${DN_PREFIX:-"/C=RU/ST=Moscow/L=Moscow/O=Red Hat B.V. CIS/OU=Solution Architecture/mail=cis-sa@redhat.ru"}
DN=${DN:-"$DN_PREFIX/CN=$CN"}
CA=${CA:-"$ROOT_CA"}
KEY_TYPE=${KEY_TYPE:-"rsa:2048"}

shift
for n in $* ; do
    ALT_NAMES="${ALT_NAMES},DNS:${n}"
done

if [ "$ALT_NAMES" = "" ] ; then
    echo "SYNTAX: $BASH_SOURCE <CN> <ALT_NAME1> [[ALT_NAME2]...]"
    echo "You must specify at least one subjectAltName for the CSR"
    exit 1
fi

ALT_NAMES=$(echo $ALT_NAMES | sed 's/^,//')

CUR_DIR=${ASSETS_PREFIX:-$(pwd)}

ASSETS=${CUR_DIR}/assets
CA_ASSETS=$ASSETS/ca

if [ -r "${ASSETS}/${CN}.key.pem" ] ; then
    #echo \
    openssl req \
	-config <(cat ${CA_ASSETS}/$CA/openssl-${CA}.cnf \
	    <(printf "[SAN]\nsubjectAltName=%s\n" $ALT_NAMES)
	) \
	-reqexts SAN \
	-new \
	-nodes \
	-sha512 \
	-key ${ASSETS}/"${CN}".key.pem \
	-out ${CA_ASSETS}/"${CN}".csr.pem \
	-subj "${DN}"
    echo "OLD KEY FOUND: just renew CSR"
else
    #echo \
    openssl req \
	-config <(cat ${CA_ASSETS}/$CA/openssl-${CA}.cnf \
	    <(printf "[SAN]\nsubjectAltName=%s\n" $ALT_NAMES)
	) \
	-reqexts SAN \
	-new \
	-nodes \
	-sha512 \
	-out ${CA_ASSETS}/"${CN}".csr.pem \
	-newkey ${KEY_TYPE} \
	-keyout ${ASSETS}/"${CN}".key.pem \
	-subj "${DN}"
fi

openssl req -text -noout -in ${CA_ASSETS}/"${CN}".csr.pem
