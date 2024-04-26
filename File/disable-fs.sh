#!/bin/bash


#                       File/disable-fs.sh
#                       run as root.
#
#                       disables mounting of non-wanted file systems.
#                       by: martin-montas
#

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

CRAM_FS_INSTALLED=$(lsmod | grep cramfs)
FILE_NAME="/etc/modprobe.d/cramfs.conf"
if [[ -z $CRAM_FS_INSTALLED ]]; then
    cat "install cramfs /bin/true" >> "$FILE_NAME"
fi

FREEVXFS_FS_INSTALLED=$(lsmod | grep freevxfs)
FREE_FILE_NAME="/etc/modprobe.d/freevxfs.conf"
if [[ -z $FREEVXFS_FS_INSTALLED ]]; then
    cat "install freevxfs /bin/true" >> "$FREE_FILE_NAME"
fi

JFFS2_FS_INSTALLED=$(lsmod | grep jffs2)
JFFS2_FILE="/etc/modprobe.d/jffs2.conf"
if [[ -z $JFFS2_FS_INSTALLED ]]; then
    cat "install jffs2 /bin/true" >> "$JFFS2_FILE"
fi

H_FS_INSTALLED=$(lsmod | grep hfs)
H_FILE="/etc/modprobe.d/hfs.conf"
if [[ -z $H_FS_INSTALLED ]]; then
    cat "install jffs2 /bin/true" >> "$H_FILE"
fi

HFSPLUS_INSTALLED=$(lsmod | grep hfsplus)
HPLUS_FILE="/etc/modprobe.d/hfsplus.conf"
if [[ -z $HFSPLUS_INSTALLED ]]; then
    cat "install hfsplus /bin/true" >> "$HPLUS_FILE"
fi

SQUASH_INSTALLED=$(lsmod | grep squashfs)
SQUASH_FILE="/etc/modprobe.d/squashfs.conf"
if [[ -z $SQUASH_INSTALLED ]]; then
    cat "install squashfs /bin/true" >> "$SQUASH_FILE"
fi

UDF_INSTALLED=$(lsmod | grep udf)
UDF_FILE="/etc/modprobe.d/udf.conf"
if [[ -z $UDF_INSTALLED ]]; then
    cat "install udf /bin/true" >> "$UDF_FILE"
fi

rmmod udf
rmmod cramfs
rmmod squashfs
rmmod hfsplus
rmmod hfs
rmmod jffs2
rmmod freevxfs
