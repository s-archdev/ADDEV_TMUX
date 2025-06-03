#!/bin/sh
# Cryptocurrency price widget for cyberpunk-tmux
# chmod +x widgets/crypto.sh

CACHE_FILE="/tmp/btc_price_cache"
CACHE_DURATION=300  # 5 minutes

get_btc_price() {
    # Check if cache exists and is recent
    if [ -f "$CACHE_FILE" ]; then
        cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
        if [ "$cache_age" -lt "$CACHE_DURATION" ]; then
            cat "$CACHE_FILE"
            return
        fi
    fi
    
    # Fetch new price
    price=$(curl -s --connect-timeout 3 --max-time 5 \
        "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT" | \
        grep -o '"price":"[^"]*"' | \
        cut -d'"' -f4 | \
        awk '{printf "%.0f", $1}')
    
    if [ -n "$price" ] && [ "$price" != "0" ]; then
        echo "$price" > "$CACHE_FILE"
        echo "$price"
    else
        # Fallback to cache or default
        if [ -f "$CACHE_FILE" ]; then
            cat "$CACHE_FILE"
        else
            echo "N/A"
        fi
    fi
}

format_price() {
    price="$1"
    if [ "$price" = "N/A" ]; then
        echo "₿ N/A"
    else
        # Add commas for thousands separator
        formatted=$(echo "$price" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
        echo "₿ $formatted"
    fi
}

main() {
    price=$(get_btc_price)
    format_price "$price"
}

main