#!/bin/bash
#
# Feature: Process Monitor & Resource Tracker
#
# Entry point:
#   monitor_run [--pid PID | --name NAME] [--interval SEC] [--duration SEC]
#     - Monitor CPU/memory usage of a process
#     - Log usage stats with timestamps
#     - Alert if thresholds exceeded
#     - Return codes: 0=success, 1=error, 2=no process
#
# Helper functions (later):
#   monitor_collect_once PID
#   monitor_check_threshold PID
#!/bin/bash

read -p "Please enter the PID: " pid
echo "You entered: $pid"

# Check if process exists
if ! ps -p "$pid" > /dev/null 2>&1; then
    echo "No process found with PID $pid"
    exit 2
fi

# Collect CPU and memory usage
cpu=$(ps -p "$pid" -o %cpu=)
mem=$(ps -p "$pid" -o %mem=)

# Show results
echo "PID $pid CPU: $cpu% MEM: $mem%"

