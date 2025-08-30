#!/bin/bash
#
# Feature: Process Sandbox Launcher
#
# Description:
#   - Launch processes with CPU/memory limits (ulimit)
#   - Optionally run under a specific user/group
#   - Log usage and exit status
#   - Cleanup temp files on exit
#

# --- Load logging utility ---
source ../utils/logging.sh

# --- Config ---
LOG_FILE="../logs/proc_master.log"
SANDBOX_DIR="/tmp/proc_sandbox.$$"   # Unique tmp dir per run

# --- Cleanup function ---
cleanup() {
    rm -rf "$SANDBOX_DIR"
    log_message "INFO" "sandbox" "Cleaned up sandbox directory $SANDBOX_DIR"
}
trap cleanup EXIT

# --- Ask user for command ---
read -rp "Enter command to run in sandbox: " cmd
if [[ -z "$cmd" ]]; then
    echo "❌ No command provided!"
    exit 1
fi

# --- Ask for limits ---
read -rp "Enter CPU time limit (seconds, 0 for none): " cpu_limit
read -rp "Enter memory limit (KB, 0 for none): " mem_limit

# --- Ask for user (optional) ---
read -rp "Run as specific user? (leave blank for current): " run_user

# --- Prepare sandbox directory ---
mkdir -p "$SANDBOX_DIR"
log_message "INFO" "sandbox" "Created sandbox directory $SANDBOX_DIR"

# --- Apply limits ---
if [[ "$cpu_limit" -gt 0 ]]; then
    ulimit -t "$cpu_limit"
    log_message "INFO" "sandbox" "Applied CPU time limit: $cpu_limit seconds"
fi

if [[ "$mem_limit" -gt 0 ]]; then
    ulimit -v "$mem_limit"
    log_message "INFO" "sandbox" "Applied memory limit: $mem_limit KB"
fi

# --- Run process ---
if [[ -n "$run_user" ]]; then
    # Requires sudo permission to switch user
    sudo -u "$run_user" bash -c "$cmd" >"$SANDBOX_DIR/output.log" 2>&1
else
    bash -c "$cmd" >"$SANDBOX_DIR/output.log" 2>&1
fi

EXIT_CODE=$?

# --- Log results ---
if [[ $EXIT_CODE -eq 0 ]]; then
    log_message "INFO" "sandbox" "Command '$cmd' completed successfully"
else
    log_message "ERROR" "sandbox" "Command '$cmd' failed with exit code $EXIT_CODE"
fi

echo "✅ Sandbox execution complete. Logs at $SANDBOX_DIR/output.log"

