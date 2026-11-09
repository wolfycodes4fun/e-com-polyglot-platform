#!/bin/bash
# Description: The following script targets a given API endpoint in the auth and order services.
# More specifically the /echo endpoints in each service. The endpoint is trigerred with a number
# of requests between the MIN & MAX requests specified.Content in JSON must be passed as a JSON file.

MIN_REQUESTS="${1:-50}"
MAX_REQUESTS="${2:-200}"
AUTH_SERVICE_LISTENING_PORT="${3:-8081}"
ORDER_SERVICE_LISTENING_PORT="${4:-8084}"
AUTH_SERVICE_CONTENT_FILE="${5:-files/payload.json}"
ORDER_SERVICE_CONTENT_FILE="${6:-files/payload.json}"

if [[ ! -f "$AUTH_SERVICE_CONTENT_FILE" || ! -f "$ORDER_SERVICE_CONTENT_FILE" ]]; then
    echo "ERROR: Please pass the correct file path to the JSON payload!"
    exit 1
fi

# Verify the payload file contains valid JSON
# if ! jq empty "$AUTH_SERVICE_CONTENT_FILE" 2>/dev/null || ! jq empty "$ORDER_SERVICE_CONTENT_FILE" 2>/dev/null; then
#   echo "Error: File contains invalid JSON."
#   exit 1
# else
#     auth_service_payload=$(cat $AUTH_SERVICE_CONTENT_FILE)
#     order_service_payload=$(cat $ORDER_SERVICE_CONTENT_FILE)
# fi

trigger_service() {
    local api_path=$1
    local port=$2
    local payload=$3

    curl -X POST "http://localhost:${port}/${api_path}" \
        --silent \
        --fail \
        --show-error \
        --output /dev/null \
        -H "Content-Type: application/json" \
        --data-binary "@$payload"
}

echo "Starting continuous load simulation..."
echo "Traffic range: $MIN_REQUESTS to $MAX_REQUESTS requests per minute."
echo "Press [CTRL+C] to stop."
echo "--------------------------------------------------"

while true; do
    requests_per_min=$(( RANDOM % (MAX_REQUESTS - MIN_REQUESTS + 1) + MIN_REQUESTS ))

    for ((i=1; i<=$requests_per_min; i++)); do
        delay=$(( RANDOM % 60 + 1 ))
        (
            sleep $delay

            # Trigger Auth & Order services 'echo' endpoint
            trigger_service "auth/echo" $AUTH_SERVICE_LISTENING_PORT $AUTH_SERVICE_CONTENT_FILE
            trigger_service "orders/echo" $ORDER_SERVICE_LISTENING_PORT $ORDER_SERVICE_CONTENT_FILE
        ) &
    done

    wait
    echo "Preparing next batch of requests..."
done
