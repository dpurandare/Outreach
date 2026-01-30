#!/bin/bash

# LinkedIn API Test Script (Lead Gen Forms & Ads Access)
# This script tests OAuth authentication and LinkedIn Lead Gen Forms API access
# Available scopes: r_ads, r_ads_leadgen_automation, r_marketing_leadgen_automation, r_organization_admin

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
SCOPES="${4:-r_ads r_ads_leadgen_automation r_marketing_leadgen_automation r_organization_admin openid profile email}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== LinkedIn API Test (Lead Gen Forms & Ads Access) ===${NC}\n"

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

# URL-encode the client secret (handles == at the end)
ENCODED_CLIENT_SECRET=$(echo -n "$CLIENT_SECRET" | sed 's/=/%3D/g')

TOKEN_RESPONSE=$(curl -s -X POST "https://www.linkedin.com/oauth/v2/accessToken" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code&code=$AUTHORIZATION_CODE&redirect_uri=$REDIRECT_URI&client_id=$CLIENT_ID&client_secret=$ENCODED_CLIENT_SECRET")

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
else
    echo -e "${RED}Profile access failed (this may be expected with new scopes)${NC}"
    ERROR_CODE=$(echo "$PROFILE_RESPONSE" | jq -r '.serviceErrorCode' 2>/dev/null)
    ERROR_MESSAGE=$(echo "$PROFILE_RESPONSE" | jq -r '.message' 2>/dev/null)
    echo "Error: $ERROR_CODE - $ERROR_MESSAGE"
fi

echo ""

# API Request 3: Get Ad Accounts
echo -e "${BLUE}=== Step 3: Getting Ad Accounts ===${NC}"
echo "Testing r_ads scope..."
echo ""

AD_ACCOUNTS_RESPONSE=$(curl -s -X GET "https://api.linkedin.com/v2/adAccountsV2?q=search" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Ad Accounts Response:"
echo "$AD_ACCOUNTS_RESPONSE" | jq '.' 2>/dev/null || echo "$AD_ACCOUNTS_RESPONSE"
echo ""

# Extract first ad account ID if available
AD_ACCOUNT_ID=""
if echo "$AD_ACCOUNTS_RESPONSE" | jq -e '.elements[0]' > /dev/null 2>&1; then
    AD_ACCOUNT_COUNT=$(echo "$AD_ACCOUNTS_RESPONSE" | jq '.elements | length')
    AD_ACCOUNT_ID=$(echo "$AD_ACCOUNTS_RESPONSE" | jq -r '.elements[0].id')
    AD_ACCOUNT_NAME=$(echo "$AD_ACCOUNTS_RESPONSE" | jq -r '.elements[0].name')

    echo -e "${GREEN}Found $AD_ACCOUNT_COUNT ad account(s)${NC}"
    echo "First Account ID: $AD_ACCOUNT_ID"
    echo "First Account Name: $AD_ACCOUNT_NAME"
else
    echo -e "${RED}No ad accounts found or access denied${NC}"
    ERROR_CODE=$(echo "$AD_ACCOUNTS_RESPONSE" | jq -r '.serviceErrorCode' 2>/dev/null)
    ERROR_MESSAGE=$(echo "$AD_ACCOUNTS_RESPONSE" | jq -r '.message' 2>/dev/null)
    if [ "$ERROR_CODE" != "null" ]; then
        echo "Error: $ERROR_CODE - $ERROR_MESSAGE"
    fi
fi

echo ""

# API Request 4: Get Lead Gen Forms (try multiple methods)
echo -e "${BLUE}=== Step 4: Getting Lead Gen Forms ===${NC}"
echo "Testing r_ads_leadgen_automation and r_marketing_leadgen_automation scopes..."
echo ""

LEAD_FORM_ID=""

# Method 1: Try with ad account if available
if [ -n "$AD_ACCOUNT_ID" ] && [ "$AD_ACCOUNT_ID" != "null" ]; then
    echo "Method 1: Querying by ad account: $AD_ACCOUNT_ID"
    ACCOUNT_URN="urn:li:sponsoredAccount:$AD_ACCOUNT_ID"

    LEAD_FORMS_RESPONSE=$(curl -s -X GET "https://api.linkedin.com/v2/leadForms?q=account&account=$ACCOUNT_URN" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "LinkedIn-Version: 202401" \
      -H "X-Restli-Protocol-Version: 2.0.0")

    echo "Response:"
    echo "$LEAD_FORMS_RESPONSE" | jq '.' 2>/dev/null || echo "$LEAD_FORMS_RESPONSE"
    echo ""
fi

# Method 2: Try direct leadForms endpoint
echo "Method 2: Querying leadForms directly..."
LEAD_FORMS_DIRECT=$(curl -s -X GET "https://api.linkedin.com/v2/leadForms" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$LEAD_FORMS_DIRECT" | jq '.' 2>/dev/null || echo "$LEAD_FORMS_DIRECT"
echo ""

# Method 3: Try leadGenFormResponses endpoint directly
echo "Method 3: Querying leadGenFormResponses..."
LEAD_RESPONSES_DIRECT=$(curl -s -X GET "https://api.linkedin.com/v2/leadGenFormResponses" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$LEAD_RESPONSES_DIRECT" | jq '.' 2>/dev/null || echo "$LEAD_RESPONSES_DIRECT"
echo ""

# Method 4: Try leadFormResponses endpoint
echo "Method 4: Querying leadFormResponses..."
LEAD_FORM_RESPONSES=$(curl -s -X GET "https://api.linkedin.com/v2/leadFormResponses" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$LEAD_FORM_RESPONSES" | jq '.' 2>/dev/null || echo "$LEAD_FORM_RESPONSES"
echo ""

# Method 5: Try Lead Sync API endpoints
echo "Method 5: Querying Lead Sync API - leadNotificationUrls..."
LEAD_NOTIFICATION=$(curl -s -X GET "https://api.linkedin.com/v2/leadNotificationUrls" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$LEAD_NOTIFICATION" | jq '.' 2>/dev/null || echo "$LEAD_NOTIFICATION"
echo ""

# Method 6: Try organization leads
echo "Method 6: Querying organization leads (if any orgs)..."
ORG_LEADS=$(curl -s -X GET "https://api.linkedin.com/v2/organizationLeadGenFormResponses" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$ORG_LEADS" | jq '.' 2>/dev/null || echo "$ORG_LEADS"
echo ""

# Method 7: Try marketing leads endpoint
echo "Method 7: Querying marketing leadFormResponses..."
MARKETING_LEADS=$(curl -s -X GET "https://api.linkedin.com/rest/leadFormResponses" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$MARKETING_LEADS" | jq '.' 2>/dev/null || echo "$MARKETING_LEADS"
echo ""

# Method 8: Try versioned API with owner query
echo "Method 8: Querying leads by owner..."
OWNER_LEADS=$(curl -s -X GET "https://api.linkedin.com/rest/leadForms?q=owner" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0")

echo "Response:"
echo "$OWNER_LEADS" | jq '.' 2>/dev/null || echo "$OWNER_LEADS"
echo ""

echo -e "${BLUE}=== Step 5: Additional Lead Sync Tests ===${NC}"
echo ""

# Test userinfo to confirm identity
echo "User Info:"
curl -s -X GET "https://api.linkedin.com/v2/userinfo" \
  -H "Authorization: Bearer $ACCESS_TOKEN" | jq '.'
echo ""

echo ""
echo -e "${GREEN}=== Test Complete ===${NC}"
echo ""
echo "Summary:"
echo "- OAuth Token: $([ -n "$ACCESS_TOKEN" ] && echo "✓ Obtained" || echo "✗ Failed")"
echo "- Profile Access: $(echo "$PROFILE_RESPONSE" | jq -e '.id' > /dev/null 2>&1 && echo "✓ Success" || echo "✗ Failed/Limited")"
echo "- Ad Accounts: $([ -n "$AD_ACCOUNT_ID" ] && [ "$AD_ACCOUNT_ID" != "null" ] && echo "✓ Found ($AD_ACCOUNT_COUNT)" || echo "✗ None found")"
echo ""
echo "Tested Lead Endpoints:"
echo "- /v2/leadForms (by account)"
echo "- /v2/leadForms (direct)"
echo "- /v2/leadGenFormResponses"
echo "- /v2/leadFormResponses"
echo "- /v2/leadNotificationUrls"
echo "- /v2/organizationLeadGenFormResponses"
echo "- /rest/leadFormResponses"
echo "- /rest/leadForms?q=owner"
echo ""
echo "Review the responses above to see which endpoints returned data."
