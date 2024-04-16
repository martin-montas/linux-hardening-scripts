#!/bin/bash

#                        Service/ls-harden-passwd.sh
#                        should be run as root
#                        Author: @eto330
#
#
#
#


# Define the AppArmor profile content for ls command
cat <<EOF > /etc/apparmor.d/usr.bin.ls
# Profile for ls command
profile /usr/bin/ls {
  # Allow read and write access to specific files
  / r,
  /etc/ r,
  /etc/passwd rw,
  /etc/group rw,

  # Allow read access to all other files and directories
  /** r,
}
EOF

# Reload AppArmor profiles
apparmor_parser -r /etc/apparmor.d/usr.bin.ls

echo "AppArmor profile for ls command (with read and write access) created and applied."
