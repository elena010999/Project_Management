#!/bin/bash
#
# utils/config.sh
#
# Configuration utility for proc_master
# - Loads default values
# - Loads user config file (proc_master.conf)
# - Provides functions to access settings
#

# -------------------------------
# Default configuration values
# -------------------------------
declare -A PM_CONFIG
PM_CONFIG[LOG_DIR]="./logs"
PM_CONFIG[LOG_LEVEL]="INFO"
PM_CONFIG[ALERT_CPU]="80"
PM_CONFIG[ALERT_MEM]="80"
PM_CONFIG[NOTIFY_METHOD]="desktop"

# -------------------------------
# Function: pm_config_init
# Description: Load config from file and override defaults
# Parameters:
#   CONFIG_PATH - path to configuration file (optional)
# -------------------------------
pm_config_init() {
    local config_file="$1"

    # If no file provided, use default
    if [[ -z "$config_file" ]]; then
        config_file="./config/proc_master.conf"
    fi

    # Check if config file exists
    if [[ -f "$config_file" ]]; then
        while IFS='=' read -r key value; do
            # Ignore comments and empty lines
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            key=$(echo "$key" | xargs)   # trim spaces
            value=$(echo "$value" | xargs)
            PM_CONFIG["$key"]="$value"
        done < "$config_file"
    fi
}

# -------------------------------
# Function: pm_config_get
# Description: Get value of a config key
# Parameters:
#   KEY     - name of the config variable
#   DEFAULT - value to return if key not set (optional)
# Returns:
#   Echoes the value
# -------------------------------
pm_config_get() {
    local key="$1"
    local default="$2"

    if [[ -n "${PM_CONFIG[$key]}" ]]; then
        echo "${PM_CONFIG[$key]}"
    else
        echo "$default"
    fi
}

# -------------------------------
# Function: pm_config_require
# Description: Ensure a config key exists, exit if missing
# Parameters:
#   KEY - name of the required config variable
# -------------------------------
pm_config_require() {
    local key="$1"

    if [[ -z "${PM_CONFIG[$key]}" ]]; then
        echo "ERROR: Required config key '$key' is missing!" >&2
        exit 1
    fi
}

# -------------------------------
# Function: pm_config_dump
# Description: Print all current config values (for debugging)
# -------------------------------
pm_config_dump() {
    echo "Current proc_master configuration:"
    for key in "${!PM_CONFIG[@]}"; do
        echo "$key=${PM_CONFIG[$key]}"
    done
}

