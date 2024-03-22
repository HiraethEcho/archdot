#!/bin/sh

# A dwm_bar function that shows the current date and time
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Date is formatted like like this: "[Mon 01-01-00 00:00:00]"
dwm_date () {
    printf "^f3^^c#bb9af7^" 
    # printf "󰸗^f2^%s^f2^󰥔^f2^%s" "$(date "+%m-%d")" "$(date "+%R")"
    printf "󰥔^f2^%s" "$(date "+%R")"
}

dwm_date
