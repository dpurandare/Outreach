#!/bin/bash

# LinkedIn API Test Script (Basic Profile Access)
# This script tests OAuth authentication and basic profile API access

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
SCOPES="${4:-r_profile_basicinfo email}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== LinkedIn API Test (Basic Profile Access) ===${NC}\n"

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

# API Request 2: Get user profile (basic test with available scopes)
echo -e "${BLUE}=== Step 2: Getting user profile ===${NC}"
echo "Testing basic profile access..."
echo ""

PROFILE_RESPONSE=$(curl -s -X GET "https://api.linkedin.com/v2/people/~" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "Profile Response:"
echo "$PROFILE_RESPONSE" | jq '.' 2>/dev/null || echo "$PROFILE_RESPONSE"
echo ""

# Check if the request was successful
if echo "$PROFILE_RESPONSE" | jq -e '.id' > /dev/null 2>&1; then
    USER_ID=$(echo "$PROFILE_RESPONSE" | jq -r '.id')
    FIRST_NAME=$(echo "$PROFILE_RESPONSE" | jq -r '.firstName.localized.en_US // .firstName')
    LAST_NAME=$(echo "$PROFILE_RESPONSE" | jq -r '.lastName.localized.en_US // .lastName')
    
    echo -e "${GREEN}Profile access successful!${NC}"
    echo "User ID: $USER_ID"
    echo "Name: $FIRST_NAME $LAST_NAME"
    
    # Note about Sales Navigator limitation
    echo ""
    echo -e "${YELLOW}Note: Sales Navigator API requires special access and different scopes.${NC}"
    echo "With current scopes (r_profile_basicinfo, email), you can access basic profile info."
    echo "For lead search functionality, you'll need Sales Navigator API access."
    
else
    echo -e "${RED}Profile access failed${NC}"
    ERROR_CODE=$(echo "$PROFILE_RESPONSE" | jq -r '.serviceErrorCode' 2>/dev/null)
    ERROR_MESSAGE=$(echo "$PROFILE_RESPONSE" | jq -r '.message' 2>/dev/null)
    echo "Error: $ERROR_CODE - $ERROR_MESSAGE"
fi

echo ""
echo -e "${GREEN}=== Test Complete ===${NC}"
