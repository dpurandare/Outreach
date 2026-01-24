#!/bin/bash

# ZOHO CRM API Test Script
# This script tests OAuth authentication and retrieves Leads from ZOHO CRM

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
if [ -z "$ZOHO_CLIENT_ID" ] || [ -z "$ZOHO_CLIENT_SECRET" ] || [ -z "$ZOHO_REDIRECT_URI" ]; then
    echo "Error: Missing required environment variables"
    echo "Please ensure ZOHO_CLIENT_ID, ZOHO_CLIENT_SECRET, and ZOHO_REDIRECT_URI are set in .env"
    exit 1
fi

# Configuration
CLIENT_ID="$ZOHO_CLIENT_ID"
CLIENT_SECRET="$ZOHO_CLIENT_SECRET"
REDIRECT_URI="$ZOHO_REDIRECT_URI"
API_DOMAIN="${ZOHO_API_DOMAIN:-https://www.zohoapis.com}"
AUTH_DOMAIN="${ZOHO_AUTH_DOMAIN:-https://accounts.zoho.com}"

# Get authorization code from command line argument
AUTHORIZATION_CODE="${1:-}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== ZOHO CRM API Test ===${NC}\n"

# Check if authorization code is provided
if [ -z "$AUTHORIZATION_CODE" ]; then
    echo -e "${RED}Error: Authorization code not provided${NC}"
    echo ""
    echo "Usage: $0 <authorization_code>"
    echo ""
    echo "Step 1: Get authorization code by visiting this URL in your browser:"
    ENCODED_REDIRECT=$(echo "$REDIRECT_URI" | sed 's/:/%3A/g; s/\//%2F/g')
    echo "${AUTH_DOMAIN}/oauth/v2/auth?scope=ZohoCRM.modules.ALL&client_id=${CLIENT_ID}&response_type=code&access_type=offline&redirect_uri=${ENCODED_REDIRECT}"
    echo ""
    echo "Step 2: After authorization, copy the 'code' parameter from the redirect URL"
    echo "Step 3: Run this script with the code:"
    echo "$0 YOUR_CODE_HERE"
    exit 1
fi

echo -e "${GREEN}Configuration:${NC}"
echo "Client ID: ${CLIENT_ID:0:20}..."
echo "Redirect URI: $REDIRECT_URI"
echo "API Domain: $API_DOMAIN"
echo "Auth Domain: $AUTH_DOMAIN"
echo ""

# Step 1: Exchange authorization code for access token
echo -e "${BLUE}=== Step 1: Exchanging authorization code for access token ===${NC}"
echo ""

TOKEN_RESPONSE=$(curl -s -X POST "${AUTH_DOMAIN}/oauth/v2/token" \
  -d "grant_type=authorization_code" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "redirect_uri=$REDIRECT_URI" \
  -d "code=$AUTHORIZATION_CODE")

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

# Extract and save refresh token if available
REFRESH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.refresh_token' 2>/dev/null)
if [ ! -z "$REFRESH_TOKEN" ] && [ "$REFRESH_TOKEN" != "null" ]; then
    echo -e "${YELLOW}Refresh Token (save this for future use):${NC}"
    echo "$REFRESH_TOKEN"
    echo ""
fi

# Step 2: Retrieve Leads from ZOHO CRM
echo -e "${BLUE}=== Step 2: Retrieving Leads from ZOHO CRM ===${NC}"
echo "Fetching first 5 leads..."
echo ""

LEADS_RESPONSE=$(curl -s -X GET "${API_DOMAIN}/crm/v2/Leads?per_page=5&fields=First_Name,Last_Name,Email,Company,Phone,Lead_Status" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "Leads API Response:"
echo "$LEADS_RESPONSE" | jq '.' 2>/dev/null || echo "$LEADS_RESPONSE"
echo ""

# Check if the request was successful
if echo "$LEADS_RESPONSE" | jq -e '.data' > /dev/null 2>&1; then
    LEAD_COUNT=$(echo "$LEADS_RESPONSE" | jq '.data | length')
    echo -e "${GREEN}Success! Retrieved $LEAD_COUNT lead(s)${NC}"
    echo ""
    
    # Display lead details in a readable format
    if [ "$LEAD_COUNT" -gt 0 ]; then
        echo -e "${BLUE}Lead Details:${NC}"
        echo "----------------------------------------"
        
        for i in $(seq 0 $((LEAD_COUNT - 1))); do
            FIRST_NAME=$(echo "$LEADS_RESPONSE" | jq -r ".data[$i].First_Name // \"N/A\"")
            LAST_NAME=$(echo "$LEADS_RESPONSE" | jq -r ".data[$i].Last_Name // \"N/A\"")
            EMAIL=$(echo "$LEADS_RESPONSE" | jq -r ".data[$i].Email // \"N/A\"")
            COMPANY=$(echo "$LEADS_RESPONSE" | jq -r ".data[$i].Company // \"N/A\"")
            PHONE=$(echo "$LEADS_RESPONSE" | jq -r ".data[$i].Phone // \"N/A\"")
            STATUS=$(echo "$LEADS_RESPONSE" | jq -r ".data[$i].Lead_Status // \"N/A\"")
            
            echo "Lead $((i + 1)):"
            echo "  Name: $FIRST_NAME $LAST_NAME"
            echo "  Email: $EMAIL"
            echo "  Company: $COMPANY"
            echo "  Phone: $PHONE"
            echo "  Status: $STATUS"
            echo "----------------------------------------"
        done
    else
        echo -e "${YELLOW}No leads found in your ZOHO CRM${NC}"
        echo "This might be expected if you haven't added any leads yet."
    fi
else
    echo -e "${RED}Failed to retrieve leads${NC}"
    
    # Check for specific errors
    ERROR_CODE=$(echo "$LEADS_RESPONSE" | jq -r '.code' 2>/dev/null)
    ERROR_MESSAGE=$(echo "$LEADS_RESPONSE" | jq -r '.message' 2>/dev/null)
    
    if [ "$ERROR_CODE" = "INVALID_TOKEN" ]; then
        echo "Error: Access token is invalid or expired"
    elif [ "$ERROR_CODE" = "NO_PERMISSION" ]; then
        echo "Error: User doesn't have permission to access Leads module"
    else
        echo "Error Code: $ERROR_CODE"
        echo "Error Message: $ERROR_MESSAGE"
    fi
fi

echo ""
echo -e "${GREEN}=== Test Complete ===${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} If you received a refresh token, save it securely."
echo "You can use it to obtain new access tokens without re-authorizing:"
echo ""
echo "curl -X POST \"${AUTH_DOMAIN}/oauth/v2/token\" \\"
echo "  -d \"grant_type=refresh_token\" \\"
echo "  -d \"client_id=$CLIENT_ID\" \\"
echo "  -d \"client_secret=$CLIENT_SECRET\" \\"
echo "  -d \"refresh_token=YOUR_REFRESH_TOKEN\""
