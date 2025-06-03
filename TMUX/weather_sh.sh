#!/bin/sh
# Weather widget for cyberpunk-tmux
# chmod +x widgets/weather.sh

CACHE_FILE="/tmp/weather_cache"
CACHE_DURATION=1800  # 30 minutes

get_weather() {
    # Check if cache exists and is recent
    if [ -f "$CACHE_FILE" ]; then
        cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
        if [ "$cache_age" -lt "$CACHE_DURATION" ]; then
            cat "$CACHE_FILE"
            return
        fi
    fi
    
    # Fetch weather data from wttr.in
    weather=$(curl -s --connect-timeout 5 --max-time 10 \
        "https://wttr.in/?format=%t+%C" 2>/dev/null | \
        head -1 | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    if [ -n "$weather" ] && [ "$weather" != "+Unknown location; please try" ]; then
        # Parse temperature and condition
        temp=$(echo "$weather" | awk '{print $1}')
        condition=$(echo "$weather" | cut -d' ' -f2-)
        
        # Map conditions to icons
        case "$condition" in
            *"Clear"*|*"Sunny"*)
                icon="☀️"
                ;;
            *"Partly cloudy"*|*"Partly"*)
                icon="⛅"
                ;;
            *"Cloudy"*|*"Overcast"*)
                icon="☁️"
                ;;
            *"Rain"*|*"Drizzle"*|*"Shower"*)
                icon="🌧️"
                ;;
            *"Snow"*|*"Sleet"*)
                icon="❄️"
                ;;
            *"Thunder"*|*"Storm"*)
                icon="⛈️"
                ;;
            *"Fog"*|*"Mist"*)
                icon="🌫️"
                ;;
            *"Wind"*)
                icon="💨"
                ;;
            *)
                icon="🌤️"
                ;;
        esac
        
        result="$icon $temp"
        echo "$result" > "$CACHE_FILE"
        echo "$result"
    else
        # Fallback to cache or default
        if [ -f "$CACHE_FILE" ]; then
            cat "$CACHE_FILE"
        else
            echo "🌤️ N/A"
        fi
    fi
}

main() {
    weather=$(get_weather)
    
    # Ensure we don't output empty strings
    if [ -z "$weather" ]; then
        echo "🌤️ N/A"
    else
        echo "$weather"
    fi
}

main