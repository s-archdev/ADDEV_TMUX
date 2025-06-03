#!/bin/sh
# Battery status widget for cyberpunk-tmux
# chmod +x widgets/battery.sh

get_battery_macos() {
    pmset -g batt | grep -E "([0-9]+%)" | awk '{
        match($0, /([0-9]+)%/, arr)
        percentage = arr[1]
        
        if ($0 ~ /AC Power/) {
            status = "⚡"
        } else if ($0 ~ /charging/) {
            status = "⚡"
        } else {
            status = "🔋"
        }
        
        printf "%s %d%%", status, percentage
    }'
}

get_battery_linux() {
    if command -v acpi >/dev/null 2>&1; then
        acpi -b | head -1 | awk -F'[,:%]' '{
            percentage = $2
            gsub(/ /, "", percentage)
            
            if ($0 ~ /Charging/) {
                status = "⚡"
            } else if ($0 ~ /Full/) {
                status = "⚡"
            } else {
                status = "🔋"
            }
            
            printf "%s %s%%", status, percentage
        }'
    else
        # Fallback to /sys/class/power_supply
        if [ -d "/sys/class/power_supply/BAT0" ]; then
            capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
            status_file="/sys/class/power_supply/BAT0/status"
            
            if [ -f "$status_file" ]; then
                bat_status=$(cat "$status_file")
                case "$bat_status" in
                    "Charging"|"Full")
                        status="⚡"
                        ;;
                    *)
                        status="🔋"
                        ;;
                esac
            else
                status="🔋"
            fi
            
            printf "%s %d%%" "$status" "$capacity"
        else
            printf "🔋 N/A"
        fi
    fi
}

main() {
    case "$(uname)" in
        "Darwin")
            get_battery_macos
            ;;
        "Linux")
            get_battery_linux
            ;;
        *)
            printf "🔋 N/A"
            ;;
    esac
}

main