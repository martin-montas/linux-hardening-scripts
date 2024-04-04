#!/bin/bash

#if [ "$EUID" -ne 0 ]
#  then echo "Please run as root"
#  exit
#fi

type=0

declare -a matching_lines
# Function to display usage instructions
usage() {
    echo "Usage: $0 [-t targets] [-s scan_type] [-l log_file]"
    echo "Options:"
    echo "  -t  Target IP addresses or range (e.g., 192.168.1.0/24)"
    echo "  -s  Scan type (e.g., TCP SYN scan, UDP scan, TCP_VER, OS, AGGR_SCAN)"
    echo "  -l  Log file to save results"
    exit 1
}

# Default values
# log_file="scan_results.txt"

# Parse command-line options
while getopts ":t:s:l:" opt; do
    case $opt in
        t)
            targets="$OPTARG"
            ;;
        s)
            scan_type="$OPTARG"
            ;;
        l)
            log_file="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Validate mandatory options
if [ -z "$targets" ] || [ -z "$scan_type" ]; then
    echo "Error: Target IP addresses and scan type are required." >&2
    usage
fi



# Validate scan type
# Add more options as needed
case "$scan_type" in
    "TCP_SYN")
        type='-sS'
        ;;
    "UDP")
        type='-sU'
        ;;

    # Checks for  OS 
    "OS")
        type='-O'
        ;;

    "AGGR_SCAN")
        type='-A'
        ;;
    # Checks for tcp versioning
    "TCP_VER")
        type='-sV'
        ;;
    *)
        echo "Error: Invalid scan type." >&2
        usage
        ;;
esac

format_command_output() {
    nmap_command=$(eval "nmap $type $targets")

    while IFS= read -r line; do
        if echo "$line" | grep -qoP '^\d+/.*$'; then
            matching_lines+=("$line")
            #echo "$line rules!!"
        fi
    done < <(echo "$nmap_command")

    
}

proper_display() {
    echo "---------------------------------------------------------"
    echo "*                  *** Scan result ***                  *"
    echo "---------------------------------------------------------"
for i in "${!matching_lines[@]}"; do
    # Split the string into individual words
    read -ra words <<< "${matching_lines[$i]}"
    # Apply color to specific words
    for j in "${!words[@]}"; do
        if [[ "${words[$j]}" == "open" ]]; then
            words[$j]="\e[1;31m${words[$j]}\e[0m"  # Apply red color to word "first"
        fi
        if [[ "${words[$j]}" == "closed" ]]; then
            words[$j]="\e[1;32m${words[$j]}\e[0m"  # Apply green color to word "second"
        fi
    done
    # Concatenate the words back into a single string
    matching_lines[$i]=$(IFS=" "; echo "${words[*]}")
done

}

# Execute Nmap scan
# echo "Running $scan_type scan on targets: $targets"

format_command_output 
proper_display
echo -e "this is the frist one: $matching_lines[1]"

# Log results if specified
#if [ -n "$log_file" ]; then
#    echo "Logging results to $log_file"
#    nmap_command_log="nmap $type $targets > '$log_file'"
#fi
#
#echo "Scan completed."
