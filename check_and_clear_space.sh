#!/bin/bash

# get the available space left on the device
size=$(df -k /var/lib/origin | tail -1 | awk '{print $4}')

# check if the available space is smaller than 5GB (5000000kB)
if (($size<5000000)); then
  # find all core files under /var/lib/origin and delete them
  find /var/lib/origin -maxdepth 1 -name "core*" -type f -exec rm -f {} \;
else
  # if there is enough space print in log file /home/ootool/checkvardir.txt
  echo "There is enough space on /var/lib/origin" > /home/ootool/checkvardir.txt
fi
