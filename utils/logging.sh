#!/bin/bash
#
# Logging utilities
#
# Levels supported: ERROR, WARN, INFO, DEBUG
# Log format: [YYYY-MM-DD HH:MM:SS] [LEVEL] [COMPONENT] message
#
# Functions to implement:
#
# pm_log_init(LOG_DIR, LOG_LEVEL)
#   - Prepare log directory
#   - Set global log level
#
# pm_log LEVEL COMPONENT MESSAGE...
#   - Write log entry with timestamp
#
# Convenience wrappers:
#   pm_info COMPONENT MESSAGE
#   pm_warn COMPONENT MESSAGE
#   pm_error COMPONENT MESSAGE
#   pm_debug COMPONENT MESSAGE

