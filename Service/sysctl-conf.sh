#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi



# Lines to be appended to the sysctl.conf file for persistent
# security thru boots.
lines=(
    "kernel.kptr_restrict=2"
    "kernel.dmesg_restrict=1"
    "kernel.printk=3 3 3 3"
    "kernel.unprivileged_bpf_disabled=1"
    "kernel.randomize_va_space=2"
    "kernel.exec-shield=1"
    "net.core.bpf_jit_harden=2"
    "dev.tty.ldisc_autoload=0"
    "vm.unprivileged_userfaultfd=0"
    "kernel.kexec_load_disabled=1"
    "kernel.sysrq=4"
    "kernel.unprivileged_userns_clone=0"
    "kernel.perf_event_paranoid=3"
    "net.ipv4.tcp_rfc1337=1"
    "net.ipv4.conf.all.rp_filter=1"
    "net.ipv4.conf.default.rp_filter=1"
    "net.ipv4.conf.all.accept_redirects=0"
    "net.ipv4.conf.default.accept_redirects=0"
    "net.ipv4.conf.all.secure_redirects=0"
    "net.ipv4.conf.default.secure_redirects=0"
    "net.ipv6.conf.all.accept_redirects=0"
    "net.ipv6.conf.default.accept_redirects=0"
    "net.ipv4.conf.all.send_redirects=0"
    "net.ipv4.conf.default.send_redirects=0"
    "net.ipv4.icmp_echo_ignore_all=1"
    "net.ipv4.conf.all.accept_source_route=0"
    "net.ipv4.conf.default.accept_source_route=0"
    "net.ipv6.conf.all.accept_source_route=0"
    "net.ipv6.conf.default.accept_source_route=0"
    "net.ipv6.conf.all.accept_ra=0"
    "net.ipv6.conf.default.accept_ra=0"
    "kernel.yama.ptrace_scope=2"
    "vm.mmap_rnd_bits=32"
    "vm.mmap_rnd_compat_bits=16"
    "fs.protected_symlinks=1"
    "fs.protected_hardlinks=1"
    "fs.protected_fifos=2"
    "fs.protected_regular=2"
    "fs.suid_dumpable=0"
)



# Append lines to the file
echo "${lines[@]}" | sudo tee -a /etc/sysctl.conf

# Apply changes (optional)
# Uncomment the following line if you want to apply changes without rebooting
sysctl -p




echo "Lines appended to /etc/sysctl.conf"
