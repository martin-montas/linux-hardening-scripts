#!/usr/bin/python
import sys
import click
import warnings
from cryptography.utils import CryptographyDeprecationWarning
with warnings.catch_warnings():
    warnings.filterwarnings('ignore', category=CryptographyDeprecationWarning)
    import paramiko as pk

@click.group()
def my_commands():
    pass

def print_output(ssh_stdout):
    """ print the line to output """
    for line in ssh_stdout:
        click.echo(line.strip('\n'))

def ssh_credentials(host,user,password):
    """ the initial credential for each connection """
    #   creates the client
    client = pk.SSHClient()
    #   passes the ssh keys
    client.load_system_host_keys()
    #   connects to the server
    client.connect(f"{host}",username=f"{user}",password=f"{password}")
    return client

@click.command()
@click.option("--host", "-h", required=True, help="the host IP", type=str)
@click.option("--user", "-u", required=True,  help="The user the you want to search for, default=root", type=str)
@click.option("--file", "-f", required=True,  help="th file the parse", type=str)
@click.option("--regex", "-r", required=True,  help="the regex to parse the file with", type=str)
@click.password_option()
def regex(host,user,file,regex,password):
    client = ssh_credentials(host,user,password)
    ssh_stdin, ssh_stdout,  ssh_stderr = client.exec_command(f"cat {file} | grep '{regex}' -P")


    print_output(ssh_stdout)

my_commands.add_command(regex)

if __name__ == "__main__":
    my_commands()
