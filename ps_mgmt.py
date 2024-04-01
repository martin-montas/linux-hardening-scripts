#!/usr/bin/python

import sys
import paramiko as pk
import click
#import rich

@click.group()
def my_commands():
    pass

def ssh_credentials(host,user,password):
    """ the initial credential for each connection """

    #   creates the client
    client = pk.SSHClient()

    #   passes the ssh keys
    client.load_system_host_keys()

    #   connects to the server
    client.connect(f"{host}",username=f"{user}",password=f"{password}")

    return client

def print_output(ssh_stdout):
    """ print the line to output """
    for line in ssh_stdout:
        click.echo(line.strip('\n'))

@click.command()
@click.option("--host", "-h", required=True, help="The host IP", type=str)
@click.option("--user","-u" , required=True, default='root',help="The user the you want to search for, default=root", type=str)
@click.password_option()
@click.option("--daemon","-d",  required=True, default='root',help="The daemon or process to inspect", type=str)
@click.option("--command", "-c",  required=False, default='status', help="The command to the daemon", type=str)
def daemon(host,user, daemon, command, password): 
    """ apply daemon-based commands """

    #   initial ssh connection to server
    client = ssh_credentials(host,user,password)

    #   runs a command
    ssh_stdin, ssh_stdout,  ssh_stderr = client.exec_command(f"systemctl {command} {daemon}")

    #   to be able to read from stdout
    print_output(ssh_stdout)

@click.command()
@click.option("--host", "-h", required=True, help="the host IP", type=str)
@click.option("--user", "-u", required=True, default='root', help="The user the you want to search for, default=root", type=str)
@click.option("--size", "-s", required=True, default='-m', help="The size that it should be displayed in memory ex:(-m,-g,-b,-k),Mega,Giga,Byte,Kilo. default Mega", type=str)
@click.password_option()
def memory(host, user, password,size): 
    """ shows free memory """

    client = ssh_credentials(host,user,password)

    #   runs a command
    ssh_stdin, ssh_stdout,  ssh_stderr = client.exec_command(f"free {size}")

    #   to be able to read from stdout
    print_output(ssh_stdout)

@click.command()
@click.option("--host", "-h", required=True, help="the host IP", type=str)
@click.option("--user", "-u", required=True, default='root', help="The user the you want to search for, default=root", type=str)
@click.password_option()
def disk(host,user,password) :
    """ command for disk related stuff """
    client = ssh_credentials(host,user,password)
    #   runs a command
    ssh_stdin, ssh_stdout,  ssh_stderr = client.exec_command("df -H")
    #   to be able to read from stdout
    print_output(ssh_stdout)

@click.command()
@click.option("--host", "-h", required=True, help="the host IP", type=str)
@click.option("--user", "-u", required=True, default='root', help="The user the you want to search for, default=root", type=str)
@click.option("--command", "-c", required=True,  help="the command that you want to run. Note: command should be passed as a string", type=str)
@click.password_option()
def command(host,user,password,command):
    """ give a whole new command not cover """

    client = ssh_credentials(host,user,password)
    #   runs a command
    ssh_stdin, ssh_stdout,  ssh_stderr = client.exec_command(f"{command}")
    #   to be able to read from stdout
    print_output(ssh_stdout)

#   this adds the commands
my_commands.add_command(daemon)
my_commands.add_command(memory)
my_commands.add_command(disk)
my_commands.add_command(command)

# should be run with the name of the function example ./main.py daemon [COMMAND] ...
if __name__ == "__main__":
    my_commands()
