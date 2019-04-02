#!/bin/bash

DIR1=env

mkdir -p $DIR1

FILE=ocp-system-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='OpenShift Container Platform container images'
export PRODUCT_LABEL='openshift3'
export IMAGE_PREFIX='openshift3'
export IMAGES="
EOF

cat << EOF | (sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE)
$ docker pull registry.redhat.io/openshift3/apb-base:<tag>
$ docker pull registry.redhat.io/openshift3/apb-tools:<tag>
$ docker pull registry.redhat.io/openshift3/automation-broker-apb:<tag>
$ docker pull registry.redhat.io/openshift3/csi-attacher:<tag>
$ docker pull registry.redhat.io/openshift3/csi-driver-registrar:<tag>
$ docker pull registry.redhat.io/openshift3/csi-livenessprobe:<tag>
$ docker pull registry.redhat.io/openshift3/csi-provisioner:<tag>
$ docker pull registry.redhat.io/openshift3/grafana:<tag>
$ docker pull registry.redhat.io/openshift3/local-storage-provisioner:<tag>
$ docker pull registry.redhat.io/openshift3/manila-provisioner:<tag>
$ docker pull registry.redhat.io/openshift3/mariadb-apb:<tag>
$ docker pull registry.redhat.io/openshift3/mediawiki:<tag>
$ docker pull registry.redhat.io/openshift3/mediawiki-apb:<tag>
$ docker pull registry.redhat.io/openshift3/mysql-apb:<tag>
$ docker pull registry.redhat.io/openshift3/ose-ansible:<tag>
$ docker pull registry.redhat.io/openshift3/ose-ansible-service-broker:<tag>
$ docker pull registry.redhat.io/openshift3/ose-cli:<tag>
$ docker pull registry.redhat.io/openshift3/ose-cluster-autoscaler:<tag>
$ docker pull registry.redhat.io/openshift3/ose-cluster-capacity:<tag>
$ docker pull registry.redhat.io/openshift3/ose-cluster-monitoring-operator:<tag>
$ docker pull registry.redhat.io/openshift3/ose-console:<tag>
$ docker pull registry.redhat.io/openshift3/ose-configmap-reloader:<tag>
$ docker pull registry.redhat.io/openshift3/ose-control-plane:<tag>
$ docker pull registry.redhat.io/openshift3/ose-deployer:<tag>
$ docker pull registry.redhat.io/openshift3/ose-descheduler:<tag>
$ docker pull registry.redhat.io/openshift3/ose-docker-builder:<tag>
$ docker pull registry.redhat.io/openshift3/ose-docker-registry:<tag>
$ docker pull registry.redhat.io/openshift3/ose-efs-provisioner:<tag>
$ docker pull registry.redhat.io/openshift3/ose-egress-dns-proxy:<tag>
$ docker pull registry.redhat.io/openshift3/ose-egress-http-proxy:<tag>
$ docker pull registry.redhat.io/openshift3/ose-egress-router:<tag>
$ docker pull registry.redhat.io/openshift3/ose-haproxy-router:<tag>
$ docker pull registry.redhat.io/openshift3/ose-hyperkube:<tag>
$ docker pull registry.redhat.io/openshift3/ose-hypershift:<tag>
$ docker pull registry.redhat.io/openshift3/ose-keepalived-ipfailover:<tag>
$ docker pull registry.redhat.io/openshift3/ose-kube-rbac-proxy:<tag>
$ docker pull registry.redhat.io/openshift3/ose-kube-state-metrics:<tag>
$ docker pull registry.redhat.io/openshift3/ose-metrics-server:<tag>
$ docker pull registry.redhat.io/openshift3/ose-node:<tag>
$ docker pull registry.redhat.io/openshift3/ose-node-problem-detector:<tag>
$ docker pull registry.redhat.io/openshift3/ose-operator-lifecycle-manager:<tag>
$ docker pull registry.redhat.io/openshift3/ose-ovn-kubernetes:<tag>
$ docker pull registry.redhat.io/openshift3/ose-pod:<tag>
$ docker pull registry.redhat.io/openshift3/ose-prometheus-config-reloader:<tag>
$ docker pull registry.redhat.io/openshift3/ose-prometheus-operator:<tag>
$ docker pull registry.redhat.io/openshift3/ose-recycler:<tag>
$ docker pull registry.redhat.io/openshift3/ose-service-catalog:<tag>
$ docker pull registry.redhat.io/openshift3/ose-template-service-broker:<tag>
$ docker pull registry.redhat.io/openshift3/ose-tests:<tag>
$ docker pull registry.redhat.io/openshift3/ose-web-console:<tag>
$ docker pull registry.redhat.io/openshift3/postgresql-apb:<tag>
$ docker pull registry.redhat.io/openshift3/registry-console:<tag>
$ docker pull registry.redhat.io/openshift3/snapshot-controller:<tag>
$ docker pull registry.redhat.io/openshift3/snapshot-provisioner:<tag>
\
$ docker pull registry.redhat.io/rhel7/etcd:3.2.22
\
$ docker pull registry.redhat.io/openshift3/metrics-cassandra:<tag>
$ docker pull registry.redhat.io/openshift3/metrics-hawkular-metrics:<tag>
$ docker pull registry.redhat.io/openshift3/metrics-hawkular-openshift-agent:<tag>
$ docker pull registry.redhat.io/openshift3/metrics-heapster:<tag>
$ docker pull registry.redhat.io/openshift3/metrics-schema-installer:<tag>
$ docker pull registry.redhat.io/openshift3/oauth-proxy:<tag>
$ docker pull registry.redhat.io/openshift3/ose-logging-curator5:<tag>
$ docker pull registry.redhat.io/openshift3/ose-logging-elasticsearch5:<tag>
$ docker pull registry.redhat.io/openshift3/ose-logging-eventrouter:<tag>
$ docker pull registry.redhat.io/openshift3/ose-logging-fluentd:<tag>
$ docker pull registry.redhat.io/openshift3/ose-logging-kibana5:<tag>
$ docker pull registry.redhat.io/openshift3/prometheus:<tag>
$ docker pull registry.redhat.io/openshift3/prometheus-alert-buffer:<tag>
$ docker pull registry.redhat.io/openshift3/prometheus-alertmanager:<tag>
$ docker pull registry.redhat.io/openshift3/prometheus-node-exporter:<tag>
"
EOF

FILE=ocp-gluster-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='OpenShift Container Storage container images'
export PRODUCT_LABEL='rhgs3'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/rhgs3/rhgs-server-rhel7
$ docker pull registry.redhat.io/rhgs3/rhgs-volmanager-rhel7
$ docker pull registry.redhat.io/rhgs3/rhgs-gluster-block-prov-rhel7
$ docker pull registry.redhat.io/rhgs3/rhgs-s3-server-rhel7
"
EOF

FILE=ocp-cfme-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat CloudForms container images'
export PRODUCT_LABEL='cfme'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/cloudforms46/cfme-openshift-postgresql
$ docker pull registry.redhat.io/cloudforms46/cfme-openshift-memcached
$ docker pull registry.redhat.io/cloudforms46/cfme-openshift-app-ui
$ docker pull registry.redhat.io/cloudforms46/cfme-openshift-app
$ docker pull registry.redhat.io/cloudforms46/cfme-openshift-embedded-ansible
$ docker pull registry.redhat.io/cloudforms46/cfme-openshift-httpd
$ docker pull registry.redhat.io/cloudforms46/cfme-httpd-configmap-generator
"
EOF

FILE=ocp-amq-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat AMQ'
export PRODUCT_LABEL='jboss-amq'
#export IMAGE_PREFIX='jboss-amq'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/jboss-amq-6/amq63-openshift:<tag>
"
EOF

FILE=ocp-jdg-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat Data Grid'
export PRODUCT_LABEL='jboss-datagrid'
#export IMAGE_PREFIX='jboss-datagrid'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/jboss-datagrid-7/datagrid71-openshift:<tag>
$ docker pull registry.redhat.io/jboss-datagrid-7/datagrid71-client-openshift:<tag>
"
EOF


FILE=ocp-jdv-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat Data Virtualization'
export PRODUCT_LABEL='jboss-datavirt'
#export IMAGE_PREFIX='jboss-datavirt'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/jboss-datavirt-6/datavirt63-openshift:<tag>
$ docker pull registry.redhat.io/jboss-datavirt-6/datavirt63-driver-openshift:<tag>
"
EOF

FILE=ocp-bpm-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat Business Process Management'
export PRODUCT_LABEL='jboss-bpm'
#export IMAGE_PREFIX='jboss-bpm'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/jboss-decisionserver-6/decisionserver64-openshift:<tag>
$ docker pull registry.redhat.io/jboss-processserver-6/processserver64-openshift:<tag>
"
EOF


FILE=ocp-eap-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat JBoss Enterprise Application Platform container images'
export PRODUCT_LABEL='jboss-eap'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/jboss-eap-6/eap64-openshift:<tag>
$ docker pull registry.redhat.io/jboss-eap-7/eap71-openshift:<tag>
"
EOF


FILE=ocp-jws-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat JBoss Web Server'
export PRODUCT_LABEL='jboss-jws'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/jboss-webserver-3/webserver31-tomcat7-openshift:<tag>
$ docker pull registry.redhat.io/jboss-webserver-3/webserver31-tomcat8-openshift:<tag>
"
EOF

FILE=ocp-jenkins-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Jenkins CI/CD Tool'
export PRODUCT_LABEL='jenkins'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/openshift3/jenkins-2-rhel7:<tag>
$ docker pull registry.redhat.io/openshift3/jenkins-agent-maven-35-rhel7:<tag>
$ docker pull registry.redhat.io/openshift3/jenkins-agent-nodejs-8-rhel7:<tag>
$ docker pull registry.redhat.io/openshift3/jenkins-slave-base-rhel7:<tag>
$ docker pull registry.redhat.io/openshift3/jenkins-slave-maven-rhel7:<tag>
$ docker pull registry.redhat.io/openshift3/jenkins-slave-nodejs-rhel7:<tag>
"
EOF

FILE=ocp-rhscl-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat Software Collection Library'
export PRODUCT_LABEL='rhscl'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/rhscl/mongodb-32-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/mysql-57-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/perl-524-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/php-56-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/postgresql-95-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/python-35-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/ruby-24-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/nodejs-6-rhel7:<tag>
$ docker pull registry.redhat.io/rhscl/mariadb-101-rhel7:<tag>
"
EOF

FILE=ocp-sso-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='Red Hat Single Sign-On container images'
export PRODUCT_LABEL='rhsso'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/redhat-sso-7/sso73-openshift:<tag>
"
EOF

FILE=ocp-jdk-images-env.sh
cat > $DIR1/$FILE << EOF
export PRODUCT_NAME='OpenJDK Java Applications'
export PRODUCT_LABEL='java'
export IMAGES="
EOF

cat << EOF | sed 's|\([^/]\+/\)|| ; s|:.*||' >> $DIR1/$FILE
$ docker pull registry.redhat.io/redhat-openjdk-18/openjdk18-openshift:<tag>
$ docker pull registry.access.redhat.com/openjdk/openjdk-11-rhel7:<tag>
"
EOF

for i in $(find $DIR1 -type f) ; do 
    source $i
    bash hammer-import_image.sh $IMAGES
    unset PRODUCT_LABEL IMAGE_PREFIX
done
