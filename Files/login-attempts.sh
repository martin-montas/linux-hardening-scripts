#!/usr/bin/bash




if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

# Extract fields from journalctl output and store in FAILED_ATTEMPTS variable
FAILED_ATTEMPTS=$(journalctl -u ssh | awk '/Failed publickey for/ { print $1, $2, $3, $11 }')

# Declare an associative array to store IP addresses and their counts
declare -A IP_ARRAY

# Read each line of FAILED_ATTEMPTS into a loop
while read -r line; do
    # Split the line into an array of fields
    fields=($line)

    # Extract the IP address from the fields array
    if [[ "${fields[3]}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        ip="${fields[3]}"
        
        # Check if IP exists in IP_ARRAY
        if [[ -n "${IP_ARRAY[$ip]}" ]]; then
            # Convert dates to Unix timestamps (seconds since epoch)
            timestamp1=$(timestamp "$date1")
            timestamp2=$(timestamp "$date2")

            # Calculate difference in seconds between the timestamps
            difference=$((timestamp2 - timestamp1))

            # Check if the timestamps occur within the same hour
            same_hour=false

            # Extract hour component from each timestamp
            hour1=$(date -d "@$timestamp1" +"%H")
            hour2=$(date -d "@$timestamp2" +"%H")

            # Compare the hour components
            if [ "$hour1" = "$hour2" ]; then
                same_hour=true
            fi

            if [["${fields[2]}"  ]]; then

# Define a threshold for "closeness" in seconds (e.g., within 60 seconds)
threshold=300  # 300 seconds = 5 minutes (adjust as needed)

# Check if the timestamps are very close together and occur within the same hour
if (( difference <= threshold )) && $same_hour; then
    echo "Dates are very close together and within the same hour."
else
    echo "Dates are not close together within the same hour."
fi



























            ((IP_ARRAY[$ip]++))
        else
            # Initialize count for new IP address
            IP_ARRAY[$ip]=1
        fi
    fi
done <<< "$FAILED_ATTEMPTS"

# Print the IP addresses and their counts
# for ip in "${!IP_ARRAY[@]}"; do
#     echo "$ip : ${IP_ARRAY[$ip]}"
# done
