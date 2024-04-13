#!/bin/sh

# A dwm_bar function to show the speed of download and upload.
# Johan Chane <johanchanex@gmail.com>
# GNU GPLv3

# Dependencies: net-tools. for cmd 'route'

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
# parameters: name_of_received_bytes, name_of_transmitted_bytes
function get_bytes {
    # Find active network interface
    #interface=$(ip route get 8.8.8.8 2>/dev/null | grep 'dev \S\+' -o | awk '{print $2}')
    # local bytes_concat_args=$(grep ${interface:-lo} /proc/net/dev | cut -d ':' -f 2 | awk -v rb="$1" -v tb="$2" '{print rb"="$1, tb"="$9}')
    local bytes_concat_args=$(grep wlan0 /proc/net/dev | cut -d ':' -f 2 | awk -v rb="$1" -v tb="$2" '{print rb"="$1, tb"="$9}')
    eval $bytes_concat_args
}

# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.
# parameters: value, old_value, now, old_time
function get_velocity {
    local timediff=$(($3 - $4))
    local vel_kb=$(echo "1000000000 * ($1 - $2) / 1024 / $timediff" | bc)
    if test "$vel_kb" -gt 1024; then
        echo $(echo "scale = 2; $vel_kb / 1024" | bc)MB/s
    else
        echo ${vel_kb}KB/s
    fi
}

function dwm_network_speed_record {
    get_bytes 'received_bytes' 'transmitted_bytes'
    old_received_bytes=$received_bytes
    old_transmitted_bytes=$transmitted_bytes
    old_time=$(date +%s%N)
}

function download_speed {
    get_velocity $received_bytes $old_received_bytes $now $old_time
}

function upload_speed {
    get_velocity $transmitted_bytes $old_transmitted_bytes $now $old_time
}

# The greater interval ($now - $old_time) is, the be exacter the speed is.
function dwm_network_speed {
    get_bytes 'received_bytes' 'transmitted_bytes'
    now=$(date +%s%N)
    # printf "^c#89b482^" 
    printf "^c#EBCB8B^" 
    printf "%s^f2^%s"  "$(download_speed)" "$(upload_speed)"
}

dwm_network_speed_record
dwm_network_speed
