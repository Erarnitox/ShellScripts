#!/bin/bash
#Display basic information about the system
echo "SYSTEM INFO:"
echo "--------------------------"
echo "Basic Information:"
echo "Date:"
date
echo "User Info:"
whoami
id
echo "Logged in users:"
who
echo "Hostname:"
hostname
echo "---------------------------"
#Find Files with suid or caps
echo "Interesting Programms:"
echo "With SUID:"
find / -perm -u=s -type f 2>/dev/null
echo "With Caps:"
getcap -r / 2>/dev/null
