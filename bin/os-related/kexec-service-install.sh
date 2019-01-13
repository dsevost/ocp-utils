#!/bin/bash

SERVICE_NAME="kexec-load"
#INSTANCABLE="@"
SYSTEMD_PREFIX="systemd/system"
SYSTEMD_SERVICE="/etc/$SYSTEMD_PREFIX/${SERVICE_NAME}${INSTANCABLE}.service"

cat > $SERVICE_NAME << EOF
[Unit]
Description=load \$(uname -r) kernel into the current kernel
Documentation=https://wiki.archlinux.org/index.php/Kexec
DefaultDependencies=no
Before=shutdown.target umount.target final.target kexec.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c '/sbin/kexec -l /boot/vmlinuz-\$(/bin/uname -r) --initrd=/boot/initramfs-\$(/bin/uname -r).img --reuse-cmdline'

[Install]
WantedBy=kexec.target
EOF

sudo \
cp -f $SERVICE_NAME $SYSTEMD_SERVICE

sudo \
chown root:root $SYSTEMD_SERVICE

sudo \
restorecon $SYSTEMD_SERVICE

sudo \
/bin/systemctl daemon-reload

sudo \
/bin/systemctl enable $SERVICE_NAME

