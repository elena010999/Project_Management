#!/bin/bash
#
# utils/notify.sh
#
# Notification utility for proc_master
# - Supports desktop notifications and email
# - Provides a unified interface for alerts
#

# -------------------------------
# Global variables
# -------------------------------
PM_NOTIFY_METHOD="desktop"   # default, can be overridden by config

# -------------------------------
# Function: pm_notify_init
# Description: Initialize notification system
# Parameters: none
# Checks if desktop notifications are available
# -------------------------------
pm_notify_init() {
    # Check if notify-send command exists for desktop notifications
    if command -v notify-send >/dev/null 2>&1; then
        PM_NOTIFY_METHOD="desktop"
    else
        echo "WARNING: notify-send not found, desktop notifications disabled."
        PM_NOTIFY_METHOD="none"
    fi
}

# -------------------------------
# Function: pm_notify
# Description: Send a notification
# Parameters:
#   LEVEL   - INFO, WARN, ERROR
#   TITLE   - notification title
#   BODY    - notification message
# -------------------------------
pm_notify() {
    local level="$1"
    local title="$2"
    shift 2
    local body="$*"

    case "$PM_NOTIFY_METHOD" in
        desktop)
            pm_notify_desktop "$title" "$body"
            ;;
        email)
            pm_notify_email "$title" "$body"
            ;;
        none)
            echo "Notification skipped: $title - $body"
            ;;
        *)
            echo "Unknown notify method: $PM_NOTIFY_METHOD"
            ;;
    esac
}

# -------------------------------
# Function: pm_notify_desktop
# Description: Show a desktop popup using notify-send
# Parameters:
#   TITLE - notification title
#   BODY  - notification message
# -------------------------------
pm_notify_desktop() {
    local title="$1"
    shift
    local body="$*"

    notify-send "$title" "$body"
}

# -------------------------------
# Function: pm_notify_email
# Description: Send an email notification (optional)
# Parameters:
#   SUBJECT - email subject
#   BODY    - email body
# -------------------------------
pm_notify_email() {
    local subject="$1"
    shift
    local body="$*"

    # This requires a working mail setup (sendmail, mailx, etc.)
    echo "$body" | mail -s "$subject" youremail@example.com
}

