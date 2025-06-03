#!/bin/sh
# CPU and Memory usage widget for cyberpunk-tmux
# chmod +x widgets/cpu_mem.sh

get_cpu_usage() {
    case "$(uname)" in
        "Darwin")
            # macOS
            top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | sed 's/%//'
            ;;
        "Linux")
            # Linux - using /proc/stat
            grep 'cpu ' /proc/stat | awk '{
                usage = ($2 + $4) * 100 / ($2 + $3 + $4 + $5)
                printf "%.0f", usage
            }'
            ;;
        *)
            echo "0"
            ;;
    esac
}

get_memory_usage() {
    case "$(uname)" in
        "Darwin")
            # macOS
            vm_stat | awk '
                /Pages free/ { free = $3 }
                /Pages active/ { active = $3 }
                /Pages inactive/ { inactive = $3 }
                /Pages speculative/ { speculative = $3 }
                /Pages wired down/ { wired = $4 }
                END {
                    gsub(/\./, "", free)
                    gsub(/\./, "", active)
                    gsub(/\./, "", inactive)
                    gsub(/\./, "", speculative)
                    gsub(/\./, "", wired)
                    
                    total = (free + active + inactive + speculative + wired) * 4096
                    used = (active + inactive + wired) * 4096
                    
                    usage = used * 100 / total
                    printf "%.0f", usage
                }'
            ;;
        "Linux")
            # Linux - using /proc/meminfo
            awk '/MemTotal|MemAvailable/ {
                if ($1 == "MemTotal:") total = $2
                if ($1 == "MemAvailable:") available = $2
            }
            END {
                used = total - available
                usage = used * 100 / total
                printf "%.0f", usage
            }' /proc/meminfo
            ;;
        *)
            echo "0"
            ;;
    esac
}

main() {
    cpu=$(get_cpu_usage)
    mem=$(get_memory_usage)
    
    # Add color based on usage levels
    if [ "$cpu" -gt 80 ]; then
        cpu_color="🔴"
    elif [ "$cpu" -gt 60 ]; then
        cpu_color="🟡"
    else
        cpu_color="🟢"
    fi
    
    if [ "$mem" -gt 80 ]; then
        mem_color="🔴"
    elif [ "$mem" -gt 60 ]; then
        mem_color="🟡"
    else
        mem_color="🟢"
    fi
    
    printf "%s %s%% %s %s%%" "$cpu_color" "$cpu" "$mem_color" "$mem"
}

main