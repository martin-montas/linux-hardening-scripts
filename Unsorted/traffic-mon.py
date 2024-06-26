#!/usr/bin/python3
#      WHAT IS DOES:
#               This code constantly listen to traffic on your local host and when a threshold is exeeded,
#               captures packets on the inteface specified with the given parameters 
#      WHY IS USEFUL:
#               This is a great way of keeping an eye on what is consuming throughput on your network
#               and also help me find bottlenecks on your computer's traffic.
#               
#      LIB VERSIONS:
#               psutil:   v5.9.4
#               scapy:    v2.5.0
#
#
from scapy.all import *
import psutil
import time

threshold = 5000                        # threshold
interval = 5
iface = 'wlan0'                         # specify the interface
target_host = 'host 10.0.0.XX'          # specify local ip
count = 10                              # amount of traffic per pcap file

def capture_and_save(filename,  iface=f"{iface}", filter=target_host, count=count):

    # Capture packets (replace 'filter' with a BPF filter if needed)
    packets = sniff(iface=iface, filter=target_host, count=count)  

    # Writes the captured packets 
    wrpcap(f"{filename}", packets)
    time.sleep(25)



# Function to calculate bandwidth usage
def calculate_bandwidth(interval=1):
    # Get the initial network usage
    initial_net_io = psutil.net_io_counters()

    # Wait for the specified interval
    time.sleep(interval)

    # Get the final network usage
    final_net_io = psutil.net_io_counters()

    # Calculate the bandwidth
    sent_bytes = final_net_io.bytes_sent - initial_net_io.bytes_sent
    recv_bytes = final_net_io.bytes_recv - initial_net_io.bytes_recv

    return sent_bytes, recv_bytes

# Function to check for network bottleneck
def check_network_bottleneck(interval=5, threshold=1000000):  # Adjust threshold as needed
    while True:
        sent_bytes, recv_bytes = calculate_bandwidth(interval)
        sent_kbps = sent_bytes / 1024 / interval
        recv_kbps = recv_bytes / 1024 / interval

        print(f"Sent: {sent_kbps:.2f} KB/s, Received: {recv_kbps:.2f} KB/s")

        # Check if any of the bandwidth exceeds the threshold
        if sent_kbps > threshold or recv_kbps > threshold:

            current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            filename = f"traffic_capture_{current_time}.pcap"
            capture_and_save(filename,  iface=iface, filter=target_host, count=count)

            print("Potential network bottleneck detected!")

# Run the function to continuously monitor network bandwidth
check_network_bottleneck(interval, threshold)
