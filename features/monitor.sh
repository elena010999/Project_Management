
#!/bin/bash
#
# monitor.sh - Process Monitor & Resource Tracker
#
# Features:
#   - Monitor CPU/memory of a specified process
#   - Log usage stats with timestamps
#   - Alert if thresholds exceeded (desktop/email notifications)
#

# ----------------------------
# Load utils
# ----------------------------
source ../utils/config.sh
source ../utils/logging.sh
source ../utils/notify.sh

# ----------------------------
# Initialize config
# ----------------------------
pm_config_init

# ----------------------------
# Set up logs
# ----------------------------
LOG_DIR="../logs"           # Folder for logs
mkdir -p "$LOG_DIR"         # Ensure the logs folder exists
pm_log_init "$LOG_DIR"      # Pass folder to logging.sh

# ----------------------------
# Initialize notifications
# ----------------------------
pm_notify_init

# ----------------------------
# Get thresholds from config
# ----------------------------
CPU_ALERT=$(pm_config_get "ALERT_CPU" 80)  # default 80%
MEM_ALERT=$(pm_config_get "ALERT_MEM" 70)  # default 70%

# ----------------------------
# Ask for PID or process name
# ----------------------------
read -p "Enter PID or process name: " target

# Determine PID
if [[ "$target" =~ ^[0-9]+$ ]]; then
    pid=$target
else
    pid=$(pgrep -n "$target")
fi

if [[ -z "$pid" ]]; then
    echo "No such process found."
    exit 2
fi

echo "Monitoring PID: $pid"

# ----------------------------
# Collect stats
# ----------------------------
stats=$(ps -p "$pid" -o pid,%cpu,%mem --no-headers)
if [[ -z "$stats" ]]; then
    echo "Process $pid not running."
    exit 2
fi

pid=$(echo "$stats" | awk '{print $1}')
cpu=$(echo "$stats" | awk '{print $2}')
mem=$(echo "$stats" | awk '{print $3}')

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
log_line="[$timestamp] PID: $pid | CPU: $cpu% | MEM: $mem%"

# ----------------------------
# Log stats
# ----------------------------
pm_info "monitor" "$log_line"

# ----------------------------
# Check thresholds
# ----------------------------
if (( $(echo "$cpu > $CPU_ALERT" | bc -l) )); then
    pm_warn "monitor" "CPU usage $cpu% exceeds threshold $CPU_ALERT%"
    pm_notify "WARN" "Proc Master Alert" "CPU $cpu% > threshold $CPU_ALERT% for PID $pid"
fi

if (( $(echo "$mem > $MEM_ALERT" | bc -l) )); then
    pm_warn "monitor" "Memory usage $mem% exceeds threshold $MEM_ALERT%"
    pm_notify "WARN" "Proc Master Alert" "Memory $mem% > threshold $MEM_ALERT% for PID $pid"
fi

