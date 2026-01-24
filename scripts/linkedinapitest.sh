#!/bin/bash

# LinkedIn Sales Navigator API Test Script
# This script tests OAuth authentication and lead search API

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../config/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

# Source the .env file
source "$ENV_FILE"

# Check required variables
if [ -z "$LINKEDIN_SALES_NAV_CLIENT_ID" ] || [ -z "$LINKEDIN_SALES_NAV_CLIENT_SECRET" ]; then
    echo "Error: Missing required environment variables"
    echo "Please ensure LINKEDIN_SALES_NAV_CLIENT_ID and LINKEDIN_SALES_NAV_CLIENT_SECRET are set in .env"
    exit 1
fi

# Configuration
CLIENT_ID="$LINKEDIN_SALES_NAV_CLIENT_ID"
CLIENT_SECRET="$LINKEDIN_SALES_NAV_CLIENT_SECRET"

# You need to set these variables or pass them as arguments
AUTHORIZATION_CODE="${1:-}"
REDIRECT_URI="${2:-http://localhost:8080/callback}"
SEARCH_NAME="${3:-John Doe}"
SCOPES="${4:-r_liteprofile r_emailaddress}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== LinkedIn Sales Navigator API Test ===${NC}\n"

# Check if authorization code is provided
if [ -z "$AUTHORIZATION_CODE" ]; then
    echo -e "${RED}Error: Authorization code not provided${NC}"
    echo ""
    echo "Usage: $0 <authorization_code> [redirect_uri] [search_name] [scopes]"
    echo ""
    echo "Step 1: Get authorization code by visiting this URL in your browser:"
    ENCODED_SCOPES=$(echo "$SCOPES" | sed 's/ /%20/g')
    echo "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=$CLIENT_ID&redirect_uri=${REDIRECT_URI}&scope=$ENCODED_SCOPES"
    echo ""
    echo "Step 2: Run this script with the code from the redirect URL:"
    echo "$0 YOUR_CODE_HERE"
    exit 1
fi

echo -e "${GREEN}Configuration:${NC}"
echo "Client ID: $CLIENT_ID"
echo "Client Secret: ${CLIENT_SECRET:0:10}... (length: ${#CLIENT_SECRET})"
echo "Redirect URI: $REDIRECT_URI"
echo "Search Name: $SEARCH_NAME"
echo ""

# API Request 1: Exchange authorization code for access token
echo -e "${BLUE}=== Step 1: Exchanging authorization code for access token ===${NC}"
echo ""

TOKEN_RESPONSE=$(curl -s -X POST https://www.linkedin.com/oauth/v2/accessToken \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "code=$AUTHORIZATION_CODE" \
  -d "redirect_uri=$REDIRECT_URI" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET")

echo "Token Response:"
echo "$TOKEN_RESPONSE" | jq '.' 2>/dev/null || echo "$TOKEN_RESPONSE"
echo ""

# Extract access token from response
ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token' 2>/dev/null)

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" = "null" ]; then
    echo -e "${RED}Error: Failed to get access token${NC}"
    echo "Response: $TOKEN_RESPONSE"
    exit 1
fi

echo -e "${GREEN}Access Token obtained successfully!${NC}"
echo "Token: ${ACCESS_TOKEN:0:20}..."
echo ""

# API Request 2: Search for leads by name
echo -e "${BLUE}=== Step 2: Searching for leads by name ===${NC}"
echo "Search query: $SEARCH_NAME"
echo ""

# URL encode the search name
ENCODED_NAME=$(echo "$SEARCH_NAME" | sed 's/ /%20/g')

LEADS_RESPONSE=$(curl -s -X GET "https://api.linkedin.com/v2/salesNavigator/leads?q=keyword&keywords=$ENCODED_NAME" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "Leads Search Response:"
echo "$LEADS_RESPONSE" | jq '.' 2>/dev/null || echo "$LEADS_RESPONSE"
echo ""

# Check if the search was successful
if echo "$LEADS_RESPONSE" | jq -e '.elements' > /dev/null 2>&1; then
    LEAD_COUNT=$(echo "$LEADS_RESPONSE" | jq '.elements | length')
    echo -e "${GREEN}Search completed! Found $LEAD_COUNT lead(s)${NC}"
    
    # Optional: Get details of first lead if available
    if [ "$LEAD_COUNT" -gt 0 ]; then
        FIRST_LEAD_ID=$(echo "$LEADS_RESPONSE" | jq -r '.elements[0].id')
        if [ "$FIRST_LEAD_ID" != "null" ]; then
            echo ""
            echo -e "${BLUE}=== Step 3 (Optional): Fetching details for first lead ===${NC}"
            echo "Lead ID: $FIRST_LEAD_ID"
            echo ""
            
            LEAD_DETAILS=$(curl -s -X GET "https://api.linkedin.com/v2/salesNavigator/leads/$FIRST_LEAD_ID" \
              -H "Authorization: Bearer $ACCESS_TOKEN")
            
            echo "Lead Details:"
            echo "$LEAD_DETAILS" | jq '.' 2>/dev/null || echo "$LEAD_DETAILS"
        fi
    fi
else
    echo -e "${RED}Search failed or returned no results${NC}"
fi

echo ""
echo -e "${GREEN}=== Test Complete ===${NC}"
