#!/bin/bash
#
# utils/logging.sh
#
# Logging utility for proc_master
# - Writes log messages with timestamp, level, and component
# - Supports different log levels: ERROR, WARN, INFO, DEBUG
# - Logs can be written to file and optionally to console
#

# -------------------------------
# Global variables
# -------------------------------
PM_LOG_DIR="./logs"       # default, can be overridden by config
PM_LOG_LEVEL="INFO"       # default, can be overridden by config

# Map log levels to numeric priority
declare -A PM_LOG_LEVELS=( ["ERROR"]=0 ["WARN"]=1 ["INFO"]=2 ["DEBUG"]=3 )

# -------------------------------
# Function: pm_log_init
# Description: Initialize log directory and set log level
# Parameters:
#   LOG_DIR   - folder to store log files
#   LOG_LEVEL - minimum level to log
# -------------------------------
pm_log_init() {
    local log_dir="$1"
    local log_level="$2"

    # Override defaults if provided
    [[ -n "$log_dir" ]] && PM_LOG_DIR="$log_dir"
    [[ -n "$log_level" ]] && PM_LOG_LEVEL="$log_level"

    # Create log directory if missing
    if [[ ! -d "$PM_LOG_DIR" ]]; then
        mkdir -p "$PM_LOG_DIR"
    fi
}

# -------------------------------
# Function: pm_log
# Description: Write a log message
# Parameters:
#   LEVEL     - ERROR, WARN, INFO, DEBUG
#   COMPONENT - which feature is logging (monitor, manager, etc.)
#   MESSAGE   - message to log
# -------------------------------
pm_log() {
    local level="$1"
    local component="$2"
    shift 2
    local message="$*"

    # Check if level is high enough to log
    local level_num=${PM_LOG_LEVELS[$level]}
    local current_level_num=${PM_LOG_LEVELS[$PM_LOG_LEVEL]}
    [[ -z "$level_num" ]] && level_num=3   # default DEBUG if unknown

    if (( level_num <= current_level_num )); then
        local timestamp
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        local log_line="[$timestamp] [$level] [$component] $message"

        # Write to log file
        echo "$log_line" >> "$PM_LOG_DIR/proc_master.log"

        # Also print to console
        echo "$log_line"
    fi
}

# -------------------------------
# Convenience wrappers
# -------------------------------
pm_info()   { pm_log "INFO" "$@"; }
pm_warn()   { pm_log "WARN" "$@"; }
pm_error()  { pm_log "ERROR" "$@"; }
pm_debug()  { pm_log "DEBUG" "$@"; }

