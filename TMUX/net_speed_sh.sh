#!/bin/sh
# Network speed widget for cyberpunk-tmux
# chmod +x widgets/net_speed.sh

CACHE_FILE="/tmp/net_stats_cache"

get_interface() {
    case "$(uname)" in
        "Darwin")
            # macOS - get primary interface
            route get default | grep interface | awk '{print $2}' | head -1
            ;;
        "Linux")
            # Linux - get default route interface
            ip route | grep default | awk '{print $5}' | head -1
            ;;
        *)
            echo "eth0"
            ;;
    esac
}

get_net_stats() {
    interface=$(get_interface)
    
    case "$(uname)" in
        "Darwin")
            # macOS
            netstat -ibn | grep "$interface" | head -1 | awk '{print $7, $10}'
            ;;
        "Linux")
            # Linux
            if [ -f "/proc/net/dev" ]; then
                grep "$interface" /proc/net/dev | awk -F'[: ]+' '{print $3, $11}'
            else
                echo "0 0"
            fi
            ;;
        *)
            echo "0 0"
            ;;
    esac
}

calculate_speed() {
    current_stats=$(get_net_stats)
    current_time=$(date +%s)
    
    if [ ! -f "$CACHE_FILE" ]; then
        echo "$current_time $current_stats" > "$CACHE_FILE"
        echo "↓ 0.0MB ↑ 0.0MB"
        return
    fi
    
    # Read previous stats
    prev_data=$(cat "$CACHE_FILE")
    prev_time=$(echo "$prev_data" | awk '{print $1}')
    prev_rx=$(echo "$prev_data" | awk '{print $2}')
    prev_tx=$(echo "$prev_data" | awk '{print $3}')
    
    # Current stats
    curr_rx=$(echo "$current_stats" | awk '{print $1}')
    curr_tx=$(echo "$current_stats" | awk '{print $2}')
    
    # Calculate time difference
    time_diff=$((current_time - prev_time))
    
    if [ "$time_diff" -lt 1 ]; then
        echo "↓ 0.0MB ↑ 0.0MB"
        return
    fi
    
    # Calculate bytes per second
    rx_bytes_per_sec=$(((curr_rx - prev_rx) / time_diff))
    tx_bytes_per_sec=$(((curr_tx - prev_tx) / time_diff))
    
    # Convert to MB/s
    rx_mbps=$(echo "$rx_bytes_per_sec" | awk '{printf "%.1f", $1/1024/1024}')
    tx_mbps=$(echo "$tx_bytes_per_sec" | awk '{printf "%.1f", $1/1024/1024}')
    
    # Handle negative values (counter reset)
    if [ "$(echo "$rx_mbps < 0" | bc -l 2>/dev/null || echo "0")" = "1" ]; then
        rx_mbps="0.0"
    fi
    if [ "$(echo "$tx_mbps < 0" | bc -l 2>/dev/null || echo "0")" = "1" ]; then
        tx_mbps="0.0"
    fi
    
    # Update cache
    echo "$current_time $current_stats" > "$CACHE_FILE"
    
    # Format output
    printf "↓ %sMB ↑ %sMB" "$rx_mbps" "$tx_mbps"
}

main() {
    # Simple fallback if bc is not available
    if ! command -v bc >/dev/null 2>&1; then
        current_stats=$(get_net_stats)
        current_time=$(date +%s)
        
        if [ ! -f "$CACHE_FILE" ]; then
            echo "$current_time $current_stats" > "$CACHE_FILE"
            echo "↓ 0MB ↑ 0MB"
            return
        fi
        
        prev_data=$(cat "$CACHE_FILE")
        prev_time=$(echo "$prev_data" | awk '{print $1}')
        prev_rx=$(echo "$prev_data" | awk '{print $2}')
        prev_tx=$(echo "$prev_data" | awk '{print $3}')
        
        curr_rx=$(echo "$current_stats" | awk '{print $1}')
        curr_tx=$(echo "$current_stats" | awk '{print $2}')
        
        time_diff=$((current_time - prev_time))
        
        if [ "$time_diff" -ge 1 ]; then
            rx_diff=$((curr_rx - prev_rx))
            tx_diff=$((curr_tx - prev_tx))
            
            if [ "$rx_diff" -ge 0 ] && [ "$tx_diff" -ge 0 ]; then
                rx_kbps=$((rx_diff / time_diff / 1024))
                tx_kbps=$((tx_diff / time_diff / 1024))
                
                printf "↓ %dKB ↑ %dKB" "$rx_kbps" "$tx_kbps"
            else
                echo "↓ 0KB ↑ 0KB"
            fi
        else
            echo "↓ 0KB ↑ 0KB"
        fi
        
        echo "$current_time $current_stats" > "$CACHE_FILE"
    else
        calculate_speed
    fi
}

main