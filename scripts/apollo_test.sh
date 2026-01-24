#!/bin/bash

# Load environment variables
source $(dirname "$0")/../config/.env

# API Endpoint for Person Enrichment
API_ENDPOINT="https://api.apollo.io/v1/people/enrich"

# Payload for the API request
PAYLOAD=$(cat <<EOF
{
  "api_key": "$APOLLO_API_KEY",
  "first_name": "Rich",
  "last_name": "Cardina",
  "email": "rich.cardinal@zirmed.com"
}
EOF
)

# Updated API request to include API key in the header
response=$(curl -s -X POST "$API_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "X-Api-Key: $APOLLO_API_KEY" \
  -d "$PAYLOAD")

# Print the response
echo "Response from Apollo API:"
echo "$response"