#!/bin/bash
#
# Feature: Process Tree Visualizer
#
# Description:
#   - Show ASCII tree of process hierarchy
#   - Include process stats (USER, CPU%, MEM%)
#   - Optionally export to DOT file for Graphviz
#

# --- Load logging utility ---
source ../utils/logging.sh

# --- Config ---
LOG_FILE="../logs/proc_master.log"
DOT_FILE="../logs/proc_tree.dot"

# --- Function: Show ASCII Tree ---
show_tree() {
    echo "🌳 Process Tree (with stats)"
    # Use ps to get PID, PPID, USER, %CPU, %MEM, CMD
    ps -eo pid,ppid,user,pcpu,pmem,comm --sort=ppid | awk '
    BEGIN {
        printf("%-6s %-6s %-10s %-5s %-5s %s\n", "PID", "PPID", "USER", "CPU%", "MEM%", "COMMAND");
        print "------------------------------------------------------------------";
    }
    {
        printf("%-6s %-6s %-10s %-5s %-5s %s\n", $1, $2, $3, $4, $5, $6);
    }'
}

# --- Function: Export to DOT ---
export_dot() {
    echo "digraph proc_tree {" > "$DOT_FILE"
    echo "  node [shape=box, style=rounded];" >> "$DOT_FILE"

    ps -eo pid,ppid,comm --sort=ppid | awk 'NR>1 {print $1, $2, $3}' | while read -r pid ppid cmd; do
        echo "  \"$ppid\" -> \"$pid\";" >> "$DOT_FILE"
        echo "  \"$pid\" [label=\"PID:$pid\nCMD:$cmd\"];" >> "$DOT_FILE"
    done

    echo "}" >> "$DOT_FILE"
    echo "✅ Process tree exported to $DOT_FILE"
    log_message "INFO" "tree" "Exported process tree to DOT file ($DOT_FILE)"
}

# --- Main Menu ---
echo "===== Process Tree Visualizer ====="
echo "1) Show ASCII process tree"
echo "2) Export process tree to DOT (Graphviz)"
echo "3) Exit"
read -rp "Choose an option: " choice

case $choice in
    1) show_tree ;;
    2) export_dot ;;
    3) echo "Bye!"; exit 0 ;;
    *) echo "Invalid choice!" ;;
esac

