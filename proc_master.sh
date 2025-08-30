#!/bin/bash
#
# Main Menu - Proc Master
# Entry point for all features

# Import utils
source ./utils/logging.sh
source ./utils/notify.sh
source ./utils/config.sh

while true; do
    clear
    echo "====================================="
    echo "         🐧 Proc Master Menu"
    echo "====================================="
    echo "1) Process Monitor & Resource Tracker"
    echo "2) Interactive Process Manager"
    echo "3) Zombie Process Cleaner"
    echo "4) Process Tree Visualizer"
    echo "5) Process Sandbox Launcher"
    echo "0) Exit"
    echo "====================================="
    read -p "Choose an option: " choice

    case $choice in
        1)
            ./features/monitor.sh
            ;;
        2)
            ./features/manager.sh
            ;;
        3)
            ./features/zombies.sh
            ;;
        4)
            ./features/tree.sh
            ;;
        5)
            ./features/sandbox.sh
            ;;
        0)
            echo "Exiting Proc Master. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            sleep 1
            ;;
    esac
done

