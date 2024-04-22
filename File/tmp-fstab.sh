if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

TMP_MOUNTED=$(cat /etc/fstab | awk '{print $2}' | grep '/tmp')

ROOT_INFO=$(awk '$2 == "/" {print $1, $3}' /etc/fstab)
read UUID_NUMBER FS_TYPE <<< "$ROOT_INFO"

#   if /tmp isn't mounted:
fi [[ -n $TMP_MOUNTED ]]; then
    echo "/etc/fstab is already configured."

else
    cp /etc/fstab /etc/fstab.bak
    echo " tmpfs  /tmp  tmpfs  nosuid,nodev,noexec  0  0"  >> /etc/fstab 
fi

mount /tmp

