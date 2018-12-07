#!/bin/bash

TMPL_NAME=${OPENSHIFT_INVENTORY_TEMPLATE_FILE:-"ocp-hosts-v311.template"}

CUTOMER_TLD=${CUSTOMER_TLD}
INTERNAL_NET=${INTERNAL_NET}

OCP_DOMAIN=${OCP_DOMAIN:-"ocp"}
APPS_DOMAIN=${APPS_DOMAIN:-"apps"}
IDM_NAME=${IDM_NAME:-"RH-IDM01"}
IDM_BIND_USER=${IDM_BIND_USER:-"ocp-proxy"}
IDM_BIND_PASSWORD=${IDM_BIND_PASSWORD:-"ocp-proxy-password"}
IDM_GROUP=${IDM_GROUP:-"ocp-access"}
IDM_CA_CERT=${IDM_CA_CERT:-"ipa-ca.crt"}
IDM_DC=${IDM_DC}
IDM_HOST=${IDM_HOST:-"idm01.$INTERNAL_NET"}

# downlaod CA form IPA server curl -o ipa-ca.crt http://ipa.example.com/ipa/config/ca.crt
CA_CERT=${CA_CERT:-"ipa-ca.crt"}

PRIVATE_DOCKER_REGISTRY_HOST=${PRIVATE_DOCKER_REGISTRY_HOST:-"satellite.$INTERNAL_NET"}

function die() {
    echo $*
    exit 1
}

[ -z "$CUSTOMER_TLD" ] && die "CUSTOMER_TLD must be set to public domain"
[ -z "$INTERNAL_NET" ] && die "INTERNAL_NET must be set to internal domain"
[ -z "$IDM_DC" ] && die "IDM_DC must be set"

DIR=$(dirname $TMPL_NAME)
TMPL_NAME=$(basename $TMPL_NAME)

BASE_DIR=$HOME

CUR_DIR=${ASSETS_PREFIX:-$(pwd)}

ASSETS=${CUR_DIR}/assets
CA_ASSETS=$ASSETS/ca/$ROOT_CA

[ -d "$CA_ASSETS" ] || mkdir -p $CA_ASSETS

for f in $TMPL_NAME {admission-plugin,idm,project-request}-fragment.yaml.template ; do
sed "
  s/\.ocp\./.${OCP_DOMAIN}./g ;
  s/apps\./${APPS_DOMAIN}./g ;
  s/\.internal\.net/.$INTERNAL_NET/g ;
  s/\.customer\.tld/.$CUSTOMER_TLD/g ;
  s/__IDM_NAME__/$IDM_NAME/g ;
  s/__IDM_BIND_PASSWORD__/$IDM_BIND_PASSWORD/g ;
  s/ocp-proxy/$IDM_BIND_USER/g ;
  s/ocp-users/$IDM_GROUP/g ;
  s/__DC__/$IDM_DC/g ;
  s/IDM_CA\.crt/$IDM_CA_CERT/g ;
  s/__IDM_HOST__/$IDM_HOST/g ;
  s/ROOT_CA\.crt/$CA_CERT/g ;
  s/__PRIVATE_DOCKER_REGISTRY_HOST__/$PRIVATE_DOCKER_REGISTRY_HOST/g ;
  s|/root/|${ASSETS}/|g ;
#  s/^# .*[^=].*// ;
" $DIR/$f > ${ASSETS}/$(echo $f | sed 's/\.template//')
done

ln -sf ${ASSETS}/$(echo $TMPL_NAME | sed 's/\.template//') ${CUR_DIR}/hosts

export CA_ROOT=${CA_ASSETS} OCSP_HOSTNAME=${IDM_HOST}
cat $DIR/openssl-fragment.cfg.template | envsubst | sed 's/__DOLLAR__/$/g' > ${CA_ASSETS}/openssl-${ROOT_CA}.cnf
