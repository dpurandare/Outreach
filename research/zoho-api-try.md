# ZOHO CRM API Test - Use Case

## Objective
Verify access to ZOHO CRM API by completing a two-step authentication and data retrieval process.

## Use Case: Test ZOHO API Access

### Background
Before building the full B2B outreach automation system, we need to confirm that:
1. We can successfully authenticate with ZOHO CRM API using OAuth 2.0
2. We have the necessary permissions to read Leads data
3. The API credentials are correctly configured

### Prerequisites
- ZOHO CRM account with API access enabled
- OAuth 2.0 Client ID and Client Secret from ZOHO Developer Console
- Redirect URI configured in ZOHO application settings

### Test Workflow

#### Step 1: OAuth 2.0 Authentication
**Goal:** Exchange authorization code for access token

**Process:**
1. User visits ZOHO authorization URL in browser
2. User logs in and grants permissions to the application
3. ZOHO redirects back with authorization code
4. Script exchanges authorization code for access token and refresh token

**API Endpoint:**
```
POST https://accounts.zoho.com/oauth/v2/token
```

**Parameters:**
- `grant_type`: authorization_code
- `client_id`: Your ZOHO Client ID
- `client_secret`: Your ZOHO Client Secret  
- `redirect_uri`: Your configured redirect URI
- `code`: Authorization code from step 3

**Expected Response:**
```json
{
  "access_token": "1000.xxx...",
  "refresh_token": "1000.yyy...",
  "expires_in": 3600,
  "token_type": "Bearer"
}
```

#### Step 2: Retrieve Leads List
**Goal:** Fetch list of Leads from ZOHO CRM to verify API access

**Process:**
1. Use the access token obtained from Step 1
2. Make GET request to Leads API endpoint
3. Display basic information about retrieved leads

**API Endpoint:**
```
GET https://www.zohoapis.com/crm/v2/Leads
```

**Headers:**
- `Authorization`: Bearer {access_token}

**Query Parameters:**
- `per_page`: 5 (limit to 5 records for testing)
- `fields`: First_Name,Last_Name,Email,Company

**Expected Response:**
```json
{
  "data": [
    {
      "id": "12345...",
      "First_Name": "John",
      "Last_Name": "Doe",
      "Email": "john.doe@example.com",
      "Company": "Example Corp"
    }
  ]
}
```

### Success Criteria
✅ OAuth token exchange completes successfully  
✅ Access token is valid and not expired  
✅ Leads API returns data without authentication errors  
✅ Lead records contain expected fields (Name, Email, Company)

### Error Scenarios to Handle
- **INVALID_CODE**: Authorization code expired (30-minute lifetime)
- **INVALID_CLIENT**: Client ID or Secret is incorrect
- **INVALID_TOKEN**: Access token expired (refresh required)
- **NO_PERMISSION**: User doesn't have access to Leads module
- **RATE_LIMIT_EXCEEDED**: API rate limits hit

### Configuration Required

Store in `config/.env`:
```bash
ZOHO_CLIENT_ID=your_client_id
ZOHO_CLIENT_SECRET=your_client_secret
ZOHO_REDIRECT_URI=http://localhost:8080/callback
ZOHO_API_DOMAIN=https://www.zohoapis.com  # or .eu/.in for other regions
```

### Next Steps After Successful Test
Once this test passes:
1. Implement refresh token logic for long-term access
2. Build bulk import functionality using `bulk/v2/write`
3. Implement upsert operations for Lead deduplication
4. Add tagging and segmentation capabilities
5. Integrate with Apollo/Sales Navigator data sources

### Notes
- Authorization code must be used within 30 minutes
- Access tokens expire after 1 hour (3600 seconds)
- Refresh tokens should be stored securely for long-term access
- Rate limits: ~100 requests/min for standard edition
- For production, implement proper error handling and retry logic

---

**Created:** January 24, 2026  
**Purpose:** Verify ZOHO CRM API access for B2B outreach automation system
