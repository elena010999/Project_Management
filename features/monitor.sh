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

