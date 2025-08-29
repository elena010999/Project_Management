#!/bin/bash
#
# manager.sh - Interactive Process Manager
#
# Features:
#   - List running processes with PID, USER, CPU%, MEM%, CMD
#   - Filter/search processes by name
#   - Send signals to selected process
#

# Load utils
source ../utils/logging.sh
source ../utils/notify.sh
pm_log_init "../logs"
pm_notify_init

while true; do
    echo "------------------------------"
    echo "Interactive Process Manager"
    echo "------------------------------"

    # Ask for search/filter term
    read -p "Enter process name to search (leave blank for all, 'q' to quit): " search_term
    [[ "$search_term" == "q" ]] && echo "Exiting..." && break

    # Get process list
    if [[ -z "$search_term" ]]; then
        processes=$(ps aux --sort=-%cpu)
    else
        processes=$(ps aux --sort=-%cpu | grep -i "$search_term" | grep -v grep)
    fi

    # Check if any process found
    if [[ -z "$processes" ]]; then
        echo "No matching processes found."
        continue
    fi

    # Display header
    printf "%-5s %-10s %-6s %-6s %s\n" "PID" "USER" "CPU%" "MEM%" "COMMAND"
    echo "-------------------------------------------------------------"

    # Display process info with numbering for selection
    declare -A pid_map
    i=1
    while read -r line; do
        pid=$(echo "$line" | awk '{print $2}')
        user=$(echo "$line" | awk '{print $1}')
        cpu=$(echo "$line" | awk '{print $3}')
        mem=$(echo "$line" | awk '{print $4}')
        cmd=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf $i " "; print ""}')
        printf "%d) %-5s %-10s %-6s %-6s %s\n" "$i" "$pid" "$user" "$cpu" "$mem" "$cmd"
        pid_map[$i]=$pid
        ((i++))
    done <<< "$processes"

    # Ask user to select a process
    read -p "Select process number to manage (or 'q' to search again): " choice
    [[ "$choice" == "q" ]] && continue

    selected_pid=${pid_map[$choice]}
    if [[ -z "$selected_pid" ]]; then
        echo "Invalid selection."
        continue
    fi

    # Ask user which action to perform
    echo "Select action for PID $selected_pid:"
    echo "1) Kill"
    echo "2) Stop"
    echo "3) Continue"
    read -p "Enter choice (1-3): " action

    case "$action" in
        1)
            kill -SIGTERM "$selected_pid"
            pm_info "manager" "Sent SIGTERM to PID $selected_pid"
            pm_notify "INFO" "Proc Master Alert" "SIGTERM sent to PID $selected_pid"
            ;;
        2)
            kill -SIGSTOP "$selected_pid"
            pm_info "manager" "Sent SIGSTOP to PID $selected_pid"
            pm_notify "INFO" "Proc Master Alert" "SIGSTOP sent to PID $selected_pid"
            ;;
        3)
            kill -SIGCONT "$selected_pid"
            pm_info "manager" "Sent SIGCONT to PID $selected_pid"
            pm_notify "INFO" "Proc Master Alert" "SIGCONT sent to PID $selected_pid"
            ;;
        *)
            echo "Invalid action."
            ;;
    esac

    echo "Action completed. Returning to process list..."
done

