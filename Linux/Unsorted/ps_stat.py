#!/usr/bin/python

# coder:    Martin Montas
# email:    martinmontas1@gmail.com
# date:     Aug-24-2023

import paramiko as pk
import click

from rich.table import Table
from rich.console import Console


@click.group()
def my_commands():
    pass

def print_output(ssh_stdout):
    """ print the line to output """
    for line in ssh_stdout:
        click.echo(line.strip('\n'))

def ssh_credentials(host,user,password,port):
    """ the initial credential for each connection """

    #   creates the client
    client = pk.SSHClient()

    #   passes the ssh keys
    client.load_system_host_keys()

    #   connects to the server
    client.connect(f"{host}",username=f"{user}",password=f"{password}",port=port)

    return client

def ssh_credentials_with_key(host,user,key):
    """ the initial credential for each connection """
    #   creates the client
    client = pk.SSHClient()

    #   passes the ssh keys
    client.load_system_host_keys()

    #   connects to the server
    client.connect(f"{host}",username=f"{user}",pkey=f"{key}")

    return client

@click.command()
@click.option("--host", "-h" , required=True, help="the ip or host domain", type=str)
@click.option("--user", "-u" , required=True, default="root", help="The user. Defaut: root", type=str)
@click.option("--file", "-f" , required=True, help="The file for the processes to the table. The file should just include a process ID number", type=str)
@click.option("--pkey", "-pk", required=False, help="The full path to the ssh key", type=str)
@click.option("--port", "-p" , required=False, default=22,help="The port for the ssh connection. Default: 22", type=int)
@click.password_option()
def process(file,host,user,password,pkey,port):
    """ this is the process command """
    table = table_creation()
    console = Console()

    # Using readlines()
    file1 = open(f"{file}", 'r+')
    Lines = file1.readlines()
    for line in Lines:
        if line.isspace(): 
            continue
        array_of_credentials = line.split()
        client = ssh_credentials(host, user, password, port)
        ssh_stdin, ssh_stdout,  ssh_stderr = client.exec_command(f"ps aux | grep '\w+\s+{array_of_credentials[0]}\s' -P")
        arr = []
        for line in ssh_stdout:
            arr.append(line.strip('\n'))
            arr = arr[0].split()

            if arr[10][0] != '[':
                table.add_row(arr[1],arr[0],arr[2],arr[3], str(arr[10]) ,"Running")

            else:
                arr[10] = arr[10].replace('[','') 
                arr[10] = arr[10].replace(']','') 
                table.add_row(arr[1],arr[0],arr[2],arr[3], str(arr[10]) ,"Running")



    console.print(table)

def table_creation():
    """ this is where the table is created """
    table = Table(title='Processes')
    table.add_column('PID', style='red')
    table.add_column('User', style='magenta')
    table.add_column('CPU%', style='blue')
    table.add_column('Memory%', style='green')
    table.add_column('Name', style='yellow')
    table.add_column('Status', style='red')

    return table

my_commands.add_command(process)

if __name__ == "__main__":
    my_commands()
