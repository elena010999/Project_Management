#!/bin/bash
#
# Feature: Zombie Process Cleaner
#
# Description:
#   - Detect zombie processes (STAT = Z)
#   - Report details (PID, PPID, CMD)
#   - Attempt cleanup by signaling parent process
#   - Log all actions using logging.sh
#

# --- Load logging utility ---
source ../utils/logging.sh

# --- Config: log file ---
LOG_FILE="../logs/proc_master.log"

# --- Function: Detect zombies ---
detect_zombies() {
    echo "🔍 Scanning for zombie processes..."
    ps -eo pid,ppid,stat,cmd | awk '$3 ~ /Z/ {print $0}'
}

# --- Function: Clean zombies ---
clean_zombies() {
    zombies=$(ps -eo pid,ppid,stat,cmd | awk '$3 ~ /Z/ {print $1 ":" $2 ":" $4}')
    
    if [ -z "$zombies" ]; then
        echo "✅ No zombie processes found."
        log_message "INFO" "zombies" "No zombie processes detected"
        return
    fi

    echo "⚠️  Found zombie processes:"
    echo "$zombies" | while IFS=":" read -r pid ppid cmd; do
        echo "Zombie PID: $pid | Parent PID: $ppid | CMD: $cmd"
        log_message "WARNING" "zombies" "Zombie detected PID=$pid (Parent=$ppid, CMD=$cmd)"

        # Try to clean by signaling parent
        if kill -s SIGCHLD "$ppid" 2>/dev/null; then
            echo "➡️  Sent SIGCHLD to parent $ppid"
            log_message "INFO" "zombies" "Sent SIGCHLD to parent $ppid for zombie $pid"
        else
            echo "❌ Failed to signal parent $ppid. Manual intervention needed."
            log_message "ERROR" "zombies" "Failed to signal parent $ppid for zombie $pid"
        fi
    done
}

# --- Main Menu ---
echo "===== Zombie Process Cleaner ====="
echo "1) Detect zombies"
echo "2) Clean zombies"
echo "3) Exit"
read -rp "Choose an option: " choice

case $choice in
    1) detect_zombies ;;
    2) clean_zombies ;;
    3) echo "Bye!"; exit 0 ;;
    *) echo "Invalid choice!" ;;
esac

