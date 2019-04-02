#!/bin/bash

#set -x

ORG=${ORGANIZATION_ID}
PRODUCT_NAME=${PRODUCT_NAME}
PRODUCT_DESC=${PRODUCT_DESC}
SYNC_PLAN_NAME=${SYNC_PLAN_NAME:-weekly}
IMAGES_PREFIX=${IMAGE_PREFIX}
IMAGES="$*"

#DEBUG_CMD=echo

REGISTRY_URL=${REGISTRY_URL:-'https://registry.access.redhat.com/'}

[ -z "$ORG" ] && { echo "ORGANIZATION_ID must be set" ; exit 1; }

[ -z "$PRODUCT_NAME" ] && { echo "PRODUCT_NAME must be set" ; exit 1; }

[ -z "$PRODUCT_LABEL" ] && { echo "PRODUCT_LABEL must be set" ; exit 1; }

[ -z "$PRODUCT_DESC" ] || PRODUCT_DESC="--description $PRODUCT_DESC"

echo "=========== Product: ${PRODUCT_LABEL}/${PRODUCT_NAME} ==============="

$DEBUG_CMD \
hammer product create \
    --name="${PRODUCT_NAME}" \
    --label="${PRODUCT_LABEL}" \
    $PRODUCT_DESC \
    --organization-id="${ORG}" \
    --sync-plan $SYNC_PLAN_NAME

n=0
for i in $IMAGES ; do
    LABEL=$(echo $i | sed  -e 's|[^/]\+/||')

    n=$((n+1))

    echo "--- $(printf '%02i' ${n})" ": $LABEL ----"
#	--name="${IMAGES_PREFIX:-$PRODUCT_LABEL}_${LABEL}" \
$DEBUG_CMD \
    hammer repository create \
	--name="${LABEL}" \
	--product="${PRODUCT_NAME}" \
	--organization-id="${ORG}" \
	--content-type='docker' \
	--publish-via-http="true" \
	--url=$REGISTRY_URL \
	--docker-upstream-name=$i
done

echo
