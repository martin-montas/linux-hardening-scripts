#### todo:

1. create  finish the sec_mode script to have a file permission mode for extra security in that sense


2. Add the following line to /etc/pam.d/system-login to add a delay of at least 4 seconds between failed login attempts:


```bash
# this file /etc/pam.d/system-login
auth optional pam_faildelay.so delay=4000000
```
3. On systems with many, or untrusted users, it is important to limit the number of processes each can run at once, therefore preventing fork bombs and other denial of service attacks. /etc/security/limits.conf determines how many processes each user, or group can have open, and is empty (except for useful comments) by default. Adding the following lines to this file will limit all users to 100 active processes, unless they use the prlimit command to explicitly raise their maximum to 200 for that session. These values can be changed according to the appropriate number of processes a user should have running, or the hardware of the box you are administrating.

```bash
* soft nproc 100
* hard nproc 200
```

```bash

#!/bin/bash

# Set the permissions for the /var/log directory
chmod 755 /var/log

# Set ownership and permissions for log files within /var/log
find /var/log -type f -exec chmod 640 {} \;

# Set ownership for log files within /var/log
chown -R root:adm /var/log

# Additional commands to adjust permissions for specific log files or directories can be added here if needed.
# For example, if you have specific log files owned by a different user or group, you can adjust their permissions accordingly.
echo "Permissions for /var/log have been set."
```

6.  Set SSH Client Alive Interval 

IF YOU IMPLEMENT THE ABOVE ALSO IMPLEMENTE THIS:

7.  Set SSH Client Alive Count Max to zero


8. Kernel self-protection

```bash
kernel.kptr_restrict=2
```
A kernel pointer points to a specific location in kernel memory. These can be very useful in exploiting the kernel, but kernel pointers are not hidden by default — it is easy to uncover them by, for example, reading the contents of /proc/kallsyms. This setting aims to mitigate kernel pointer leaks. Alternatively, you can set kernel.kptr_restrict=1 to only hide kernel pointers from processes without the CAP_SYSLOG capability.


``` bash
kernel.dmesg_restrict=1
```
dmesg is the kernel log. It exposes a large amount of useful kernel debugging information, but this can often leak sensitive information, such as kernel pointers. Changing the above sysctl restricts the kernel log to the CAP_SYSLOG capability. 

```bash
kernel.printk=3 3 3 3
```
Despite the value of dmesg_restrict, the kernel log will still be displayed in the console during boot. Malware that is able to record the screen during boot may be able to abuse this to gain higher privileges. This option prevents those information leaks. This must be used in combination with certain boot parameters described below to be fully effective.

```bash
kernel.unprivileged_bpf_disabled=1
net.core.bpf_jit_harden=2
```
eBPF exposes quite large attack surface. As such, it must be restricted. These sysctls restrict eBPF to the CAP_BPF capability (CAP_SYS_ADMIN on kernel versions prior to 5.8) and enable JIT hardening techniques, such as constant blinding.

```bash
dev.tty.ldisc_autoload=0
```
This restricts loading TTY line disciplines to the CAP_SYS_MODULE capability to prevent unprivileged attackers from loading vulnerable line disciplines with the TIOCSETD ioctl, which has been abused in a number of exploits before.

```bash
vm.unprivileged_userfaultfd=0
```
The userfaultfd() syscall is often abused to exploit use-after-free flaws. Due to this, this sysctl is used to restrict this syscall to the CAP_SYS_PTRACE capability.

```bash
kernel.kexec_load_disabled=1
```
kexec is a system call that is used to boot another kernel during runtime. This functionality can be abused to load a malicious kernel and gain arbitrary code execution in kernel mode, so this sysctl disables it.

```bash
kernel.sysrq=4
```
The SysRq key exposes a lot of potentially dangerous debugging functionality to unprivileged users. Contrary to common assumptions, SysRq is not only an issue for physical attacks, as it can also be triggered remotely. The value of this sysctl makes it so that a user can only use the secure attention key, which will be necessary for accessing root securely. Alternatively, you can simply set the value to 0 to disable SysRq completely.

```bash
kernel.unprivileged_userns_clone=0
```
User namespaces are a feature in the kernel which aim to improve sandboxing and make it easily accessible for unprivileged users. However, this feature exposes significant kernel attack surface for privilege escalation, so this sysctl restricts the usage of user namespaces to the CAP_SYS_ADMIN capability. For unprivileged sandboxing, it is instead recommended to use a setuid binary with little attack surface to minimise the potential for privilege escalation. This topic is covered further in the sandboxing section.

Be aware though that this sysctl only exists on certain Linux distributions, as it requires a kernel patch. If your kernel does not include this patch, you can alternatively disable user namespaces completely (including for root) by setting user.max_user_namespaces=0.

```bash
kernel.perf_event_paranoid=3
```
Performance events add considerable kernel attack surface and have caused abundant vulnerabilities. This sysctl restricts all usage of performance events to the CAP_PERFMON capability (CAP_SYS_ADMIN on kernel versions prior to 5.8).

Be aware that this sysctl also requires a kernel patch that is only available on certain distributions. Otherwise, this setting is equivalent to kernel.perf_event_paranoid=2, which only restricts a subset of this functionality.
2.2.2 Network

```bash
net.ipv4.tcp_syncookies=1
```
This helps protect against SYN flood attacks, which are a form of denial-of-service attack, in which an attacker sends a large amount of bogus SYN requests in an attempt to consume enough resources to make the system unresponsive to legitimate traffic.

```bash
net.ipv4.tcp_rfc1337=1
```
This protects against time-wait assassination by dropping RST packets for sockets in the time-wait state.

```bash
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
```
These enable source validation of packets received from all interfaces of the machine. This protects against IP spoofing, in which an attacker sends a packet with a fraudulent IP address.

```bash
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
```
These disable ICMP redirect acceptance and sending to prevent man-in-the-middle attacks and minimise information disclosure.

```bash
net.ipv4.icmp_echo_ignore_all=1
```
This setting makes your system ignore all ICMP requests to avoid Smurf attacks, make the device more difficult to enumerate on the network and prevent clock fingerprinting through ICMP timestamps.

```bash
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
net.ipv6.conf.all.accept_source_route=0
net.ipv6.conf.default.accept_source_route=0

Source routing is a mechanism that allows users to redirect network traffic. As this can be used to perform man-in-the-middle attacks in which the traffic is redirected for nefarious purposes, the above settings disable this functionality.

```bash
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.default.accept_ra=0
```
Malicious IPv6 router advertisements can result in a man-in-the-middle attack, so they should be disabled.

```bash
net.ipv4.tcp_sack=0
net.ipv4.tcp_dsack=0
net.ipv4.tcp_fack=0
```
This disables TCP SACK. SACK is commonly exploited and unnecessary in many circumstances, so it should be disabled if it is not required.
2.2.3 User space

```bash
kernel.yama.ptrace_scope=2
```
ptrace is a system call that allows a program to alter and inspect another running process, which allows attackers to trivially modify the memory of other running programs. This restricts usage of ptrace to only processes with the CAP_SYS_PTRACE capability. Alternatively, set the sysctl to 3 to disable ptrace entirely.


```bash
vm.mmap_rnd_bits=32
vm.mmap_rnd_compat_bits=16

ASLR is a common exploit mitigation which randomises the position of critical parts of a process in memory. This can make a wide variety of exploits harder to pull off, as they first require an information leak. The above settings increase the bits of entropy used for mmap ASLR, improving its effectiveness.

The values of these sysctls must be set in relation to the CPU architecture. The above values are compatible with x86, but other architectures may differ.

```bash
fs.protected_symlinks=1
fs.protected_hardlinks=1
```
This only permits symlinks to be followed when outside of a world-writable sticky directory, when the owner of the symlink and follower match or when the directory owner matches the symlink's owner. This also prevents hardlinks from being created by users that do not have read/write access to the source file. Both of these prevent many common TOCTOU races.

```bash
fs.protected_fifos=2
fs.protected_regular=2
```
These prevent creating files in potentially attacker-controlled environments, such as world-writable directories, to make data spoofing attacks more difficult.


add the following to your /etc/NetworkManager/conf.d/00-macrandomize.conf:
```bash
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
```
