
#!/bin/sh

#
# Attention
# This shell script need jq command
#
CACHE="$HOME/.cache/weather"
EXPIRE=600
URL="https://wttr.in/China,Jiangxi?format=j1"

icon() {
    case "$1" in
        113) echo "" ;; # Sunny
        116) echo "" ;; # Partly cloudy
        119) echo "" ;; # Cloudy
        122) echo "" ;; # Very cloudy
        143|248|260) echo "" ;; # Fog
        176|263|266) echo "" ;; # Light rain
        293|296|299|302) echo "" ;; # Rain
        305|308) echo "" ;; # Heavy rain
        179|182|185|317|320) echo "" ;; # Sleet
        227|230|323|326|329|332|335|338) echo "" ;; # Snow
        *) echo "" ;; # Default
    esac
}

# Use cache if valid
if [ -f "$CACHE" ]; then
    NOW=$(date +%s)
    MOD=$(stat -c %Y "$CACHE")
    AGE=$((NOW - MOD))
    if [ "$AGE" -lt "$EXPIRE" ]; then
        cat "$CACHE"
        exit 0
    fi
fi

# Fetch JSON
JSON=$(curl -fs "$URL")
if [ $? -ne 0 ] || [ -z "$JSON" ]; then
    [ -f "$CACHE" ] && cat "$CACHE" && exit 0
    echo "N/A"
    exit 0
fi

# Parse
CODE=$(printf "%s" "$JSON" | jq -r '.current_condition[0].weatherCode')
TEMP=$(printf "%s" "$JSON" | jq -r '.current_condition[0].temp_C')

ICON=$(icon "$CODE")
OUTPUT="$ICON ${TEMP}°C"
printf "%s" "$OUTPUT" | tee "$CACHE"

