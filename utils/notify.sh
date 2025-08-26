#!/bin/bash
#
# Notification utilities
#
# Supported backends:
#   - Desktop (notify-send)
#   - Email (sendmail/mail)
#
# Functions to implement:
#
# pm_notify_init()
#   - Read notification settings from config
#
# pm_notify LEVEL TITLE BODY
#   - Unified notification call (selects backend)
#
# Backends:
#   pm_notify_desktop TITLE BODY
#   pm_notify_email SUBJECT BODY

