#!/us/bin/python3
#
#
#
#
#
#
#
'''
adds to services configs for security:

                    NoNewPrivileges=yes
                    PrivateTmp=yes
                    PrivateDevices=yes
                    DevicePolicy=closed
                    ProtectSystem=strict
                    ProtectHome=read-only
                    ProtectControlGroups=yes
                    ProtectKernelModules=yes
                    ProtectKernelTunables=yes
                    RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6 AF_NETLINK
                    RestrictNamespaces=yes
                    RestrictRealtime=yes
                    RestrictSUIDSGID=yes
                    MemoryDenyWriteExecute=yes
                    LockPersonality=yes

'''
import sys

import argparse
import subprocess
import paramiko



##############################################
#       this following functions are just 
#       local/remote bash scripts executions 
##############################################
def remote_bash_exec(ip, username, password, file):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  # Auto-accept host key

    try:
      ssh.connect(hostname=ip, username=username, password=password)
    except paramiko.AuthenticationException:
      print("Authentication failed!")
      exit()
    except Exception as e:
      print("Connection error:", e)
      exit()

    stdin, stdout, stderr = ssh.exec_command(f"bash {file}")

    # Read and process the output
    output = stdout.read().decode()
    print(output)

    # Check for errors
    error = stderr.read().decode()
    if error:
        print("Error:", error)


def local_bash_exec(command):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # Get the output and error
    output, error = process.communicate()

    # Decode output and error from bytes to string
    ouput = output.decode()
    error = error.decode()

    return output , error

##############################################
#       this following functions are just 
#       local/remote executions 
##############################################
def remote_exec(ip, username, password, command):

    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    ssh_client.connect(ip, username=username, password=password)
    print("Connected to server.")

    # Execute command with sudo privileges
    stdin, stdout, stderr = ssh_client.exec_command(command)

    # Process output and errors
    output = stdout.read().decode()
    error = stderr.read().decode()

    return  output, error
def local_exec(command):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Get the output and error
    output, error = process.communicate()

    # Decode output and error from bytes to string
    ouput = output.decode()
    error = error.decode()

    return output , error

def disable_services(services):
    '''
            disables the given systemd services
            that are are not usually used  
    '''

    '''
    for service in services:
        subprocess.run(['systemctl', 'stop', service])
        subprocess.run(['systemctl', 'disable', service])
        print(f"Disabled service: {service}")
    '''

if __name__ == '__main__':

    # Create ArgumentParser object
    parser = argparse.ArgumentParser(description=
                                     'Script that works by securing your local or remote systems with few different configuration. ')
    # Add arguments
    parser.add_argument('-r', '--remote', type=bool, help='Does the command that are about to run should be remote or local (should be "true" or "false").')
    parser.add_argument( '--ssh', type=bool,  help='Should we enfore the SSH  hardening script.')
    parser.add_argument( '--ip', type=str,  help='IP of the remote server')
    parser.add_argument( '--user', type=str,  help='User of the remote server')
    parser.add_argument( '--pass', type=str,  help='Password of the remote server')
    parser.add_argument( '--port', type=int,  help='port of the remote server, (default 22)')
    parser.add_argument( '--systemd', type=bool,  help='Should we enfore the SYSTEMD  hardening script.')
    parser.add_argument( '--service_list', type=list,  help='list of services that should be disabled.')
    parser.add_argument( '--file', type=list,  help='Harderns file permissions. Options: (true/false).')

    # Parse arguments
    args = parser.parse_args()

    REMOTE_SET = False
    # should the script  be run remotely 
    if (args.ip and args.user and args.password):
        REMOTE_SET = True
        if (args.systemd and not args.service_list) or (args.service_list and not args.systemd):
            print("You should use both the --systemd and service_list command.")
            sys.exit(1)
        if args.ssh and args.file:
            print("You should use one not both the --file and --ssh command together (pick one).")
            sys.exit(1)
    if args.ssh:

        if REMOTE_SET:
            ssh_command = 'sudo sed -i "s/^PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config'
            output ,stderr = remote_exec(args.ip, args.user, args.password, ssh_command)
            if stderr:
                print(stderr)
                sys.exit(1)
            if output:
                print(output)
                sys.exit(0)

        if not REMOTE_SET:
            local_command = 'sudo sed -i "s/^PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config'
            output ,stderr = local_exec(local_command)
            if stderr:
                print(stderr)
                sys.exit(1)
            if output:
                print(output)
                sys.exit(0)

    if args.file:
        if REMOTE_SET:
            file = 'bash/test.sh'
            remote_bash_exec(args.ip ,args.user, args.password, file)
            sys.exit(0)
        if not REMOTE_SET:
            local_command = 'chmod 700 /boot /usr/src /lib/modules /usr/lib/modules'
            output ,stderr = local_exec(local_command)
            sys.exit(0)

    else:
        print ("Couldn't load the program.")
        sys.exit(1)
