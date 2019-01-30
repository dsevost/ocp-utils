#!/bin/bash

set -e

TMPL_NAME=${OPENSHIFT_INVENTORY_TEMPLATE_FILE:-"ocp-hosts-v311.template"}

CUTOMER_TLD=${CUSTOMER_TLD}
INTERNAL_DOMAIN=${INTERNAL_DOMAIN:-"$CUSTOMER_TLD"}

OCP_DOMAIN=${OCP_DOMAIN:-"ocp"}
APPS_DOMAIN=${APPS_DOMAIN:-"apps"}
SDN_DOMAIN=${SDN_DOMAIN:-"$INTERNAL_DOMAIN"}
GLUSTER_DOMAIN=${GLUSTER_DOMAIN:-"$INTERNAL_DOMAIN"}
IDM_NAME=${IDM_NAME:-"RH-IDM01"}
IDM_BIND_USER=${IDM_BIND_USER:-"ocp-proxy"}
IDM_BIND_PASSWORD=${IDM_BIND_PASSWORD:-"ocp-proxy-password"}
IDM_GROUP=${IDM_GROUP:-"ocp-access"}
IDM_CA_CERT=${IDM_CA_CERT:-"ipa-ca.crt"}
IDM_DC=${IDM_DC}
IDM_HOST=${IDM_HOST:-"idm01.$INTERNAL_DOMAIN"}

OCP_HOST_NAME_PREFIX=${OCP_HOST_NAME_PREFIX:-""}
OCP_HOST_NAME_SUFFIX=${OCP_HOST_NAME_SUFFIX:-""}
OCP_HOST_NAME_PATTERN_MASTER=${OCP_HOST_NAME_PATTERN_MASTER:-"master"}
OCP_HOST_NAME_PATTERN_INFRA=${OCP_HOST_NAME_PATTERN_INFRA:-"infra"}
OCP_HOST_NAME_PATTERN_WORKER=${OCP_HOST_NAME_PATTERN_WORKER:-"node"}

# downlaod CA form IPA server curl -o ipa-ca.crt http://ipa.example.com/ipa/config/ca.crt
CA_CERT=${CA_CERT:-"ipa-ca.crt"}

PRIVATE_DOCKER_REGISTRY_HOST=${PRIVATE_DOCKER_REGISTRY_HOST:-"satellite.$INTERNAL_DOMAIN"}

GOLD_STORAGE_CLASS=${GOLD_STORAGE_CLASS:-"gold"}
SILVER_STORAGE_CLASS=${SILVER_STORAGE_CLASS:-"silver"}
BRONZE_STORAGE_CLASS=${BRONZE_STORAGE_CLASS:-"bronze"}
IRON_STORAGE_CLASS=${IRON_STORAGE_CLASS:-"iron"}


function die() {
    echo $*
    exit 1
}

[ -z "$CUSTOMER_TLD" ] && die "CUSTOMER_TLD must be set to public domain"
[ -z "$INTERNAL_DOMAIN" ] && die "INTERNAL_DOMAIN must be set to internal domain"
[ -z "$IDM_DC" ] && die "IDM_DC must be set"

DIR=$(dirname $TMPL_NAME)
TMPL_NAME=$(basename $TMPL_NAME)

BASE_DIR=$HOME

CUR_DIR=${ASSETS_PREFIX:-$(pwd)}

ASSETS=${CUR_DIR}/assets
CA_ASSETS=$ASSETS/ca/$ROOT_CA

[ -d "$CA_ASSETS" ] || mkdir -p $CA_ASSETS

for f in $TMPL_NAME \
    {admission-plugin,idm,project-request}-fragment.yaml.template \
    {gluster,hawkular,logging,prometheus}-fragment.yaml.template 
do
sed "
  s/master\[1:3\]/${OCP_HOST_NAME_PREFIX}${OCP_HOST_NAME_PATTERN_MASTER}[1:3]$OCP_HOST_NAME_SUFFIX/g ;
  s/infra\[1:3\]/${OCP_HOST_NAME_PREFIX}${OCP_HOST_NAME_PATTERN_INFRA}[1:3]$OCP_HOST_NAME_SUFFIX/g ;
  s/node\[1:3\]/${OCP_HOST_NAME_PREFIX}${OCP_HOST_NAME_PATTERN_WORKER}[1:3]$OCP_HOST_NAME_SUFFIX/g ;
  s/\.ocp\./.${OCP_DOMAIN}./g ;
  s/apps\./${APPS_DOMAIN}./g ;
  s/gluster\./${GLUSTER_DOMAIN}./g ;
  s/sdn\./${SDN_DOMAIN}./g ;
  s/\.internal\.net/.$INTERNAL_DOMAIN/g ;
  s/\.customer\.tld/.$CUSTOMER_TLD/g ;
  s/ROOT_CA\.crt/$CA_CERT/g ;
  s/__IDM_NAME__/$IDM_NAME/g ;
  s/__IDM_BIND_PASSWORD__/$IDM_BIND_PASSWORD/g ;
  s/IDM_CA\.crt/$IDM_CA_CERT/g ;
  s/ocp-proxy/$IDM_BIND_USER/g ;
  s/ocp-users/$IDM_GROUP/g ;
  s/__DC__/$IDM_DC/g ;
  s/__IDM_HOST__/$IDM_HOST/g ;
  s/__PRIVATE_DOCKER_REGISTRY_HOST__/$PRIVATE_DOCKER_REGISTRY_HOST/g ;
  s|/root/|${ASSETS}/|g ;
  s/gold\.storageclass/${GOLD_STORAGE_CLASS}.storageclass/g ;
  s/silver\.storageclass/${SILVER_STORAGE_CLASS}.storageclass/g ;
  s/bronze\.storageclass/${BRONZE_STORAGE_CLASS}.storageclass/g ;
  s/iron\.storageclass/${IRON_STORAGE_CLASS}.storageclass/g ;
  /^# .*[^=].*/d ;
" $DIR/$f > ${ASSETS}/$(echo $f | sed 's/\.template//')
done

#for f in {gluster,hawkular,logging,prometheus}-inline.yaml.template ; do
#    cat $DIR/$f >> ${ASSETS}/$(echo $TMPL_NAME | sed 's/\.template//')
#done

ln -sf ${ASSETS}/$(echo $TMPL_NAME | sed 's/\.template//') ${CUR_DIR}/hosts

export CA_ROOT=${CA_ASSETS} OCSP_HOSTNAME=${IDM_HOST}
cat $DIR/openssl-fragment.cfg.template | envsubst | sed 's/__DOLLAR__/$/g' > ${CA_ASSETS}/openssl-${ROOT_CA}.cnf
