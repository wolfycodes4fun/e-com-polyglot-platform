#!/bin/bash
# Description: The following script targets a given API endpoint in the auth and order services.
# More specifically the /echo endpoints in each service.
# Content in JSON must be passed as a JSON file.

LOAD_SIZE="${1:-200}"
AUTH_SERVICE_LISTENING_PORT="${2:-8081}"
ORDER_SERVICE_LISTENING_PORT="${3:-8084}"
AUTH_SERVICE_CONTENT_FILE="${4:-files/payload.json}"
ORDER_SERVICE_CONTENT_FILE="${5:-files/payload.json}"

if [ ! -f "$AUTH_SERVICE_CONTENT_FILE" || ! -f "$ORDER_SERVICE_CONTENT_FILE" ]; then
    echo "ERROR: Please pass the correct file path to the JSON payload!"
    exit 1
fi

# Verify the payload file contains valid JSON
if ! jq empty "$AUTH_SERVICE_CONTENT_FILE" 2>/dev/null || ! jq empty "$ORDER_SERVICE_CONTENT_FILE" 2>/dev/null; then
  echo "Error: File contains invalid JSON."
  exit 1
else
    auth_service_payload=$(cat $AUTH_SERVICE_CONTENT_FILE)
    order_service_payload=$(cat $ORDER_SERVICE_CONTENT_FILE)
fi

# Trigger Auth service
curl -X POST "http://localhost:${AUTH_SERVICE_LISTENING_PORT}/auth/echo" \
    -H "Content-Type: application/json" \
    -d $auth_service_payload

curl -X POST "http://localhost:${ORDER_SERVICE_LISTENING_PORT}/orders/echo" \
    -H "Content-Type: application/json" \
    -d $order_service_payload
