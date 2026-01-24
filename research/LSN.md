# LinkedIn Sales Navigator API - Quick Start Guide

## Prerequisites

⚠️ **Important:** Having Sales Navigator access from your organization doesn't automatically give you API access. The API is **not publicly available** and is restricted to LinkedIn partners or organizations with special agreements.

### Required Steps:
1. **Register an application** with LinkedIn Developer Platform
2. **Obtain client credentials** (client_id and client_secret)
3. **Contact LinkedIn** to request API access even if you have Sales Navigator subscription
4. **Set up a redirect URI** for OAuth callback

## OAuth 2.0 Authentication Flow

### Step 1: Get Authorization Code

First, direct the user to the LinkedIn authorization URL in a browser:

```
https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id={your_client_id}&redirect_uri={your_redirect_uri}&scope=r_liteprofile%20r_salesnavigatorapi
```

Replace:
- `{your_client_id}` - Your LinkedIn app client ID
- `{your_redirect_uri}` - Your registered redirect URI (URL-encoded)

The user will be redirected back to your redirect_uri with a `code` parameter.

### Step 2: Exchange Authorization Code for Access Token

```bash
curl -X POST https://www.linkedin.com/oauth/v2/accessToken \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "code={your_authorization_code}" \
  -d "redirect_uri={your_redirect_uri}" \
  -d "client_id={your_client_id}" \
  -d "client_secret={your_client_secret}"
```

**Example Response:**
```json
{
  "access_token": "AQV8...",
  "expires_in": 5184000,
  "token_type": "Bearer"
}
```

## API Requests

### Search Leads by Name

```bash
curl -X GET "https://api.linkedin.com/v2/salesNavigator/leads?q=keyword&keywords=John%20Doe" \
  -H "Authorization: Bearer {access_token}"
```

**Example with actual name:**
```bash
curl -X GET "https://api.linkedin.com/v2/salesNavigator/leads?q=keyword&keywords=Jane%20Smith" \
  -H "Authorization: Bearer AQV8..."
```

**Response Example:**
```json
{
  "elements": [
    {
      "id": "lead_id",
      "firstName": "Jane",
      "lastName": "Smith",
      "title": "VP of Sales",
      "company": "Example Corp",
      "profileUrl": "https://www.linkedin.com/in/janesmith"
    }
  ]
}
```

### Get Lead Details by ID

```bash
curl -X GET "https://api.linkedin.com/v2/salesNavigator/leads/{lead_id}" \
  -H "Authorization: Bearer {access_token}"
```

**Response Example:**
```json
{
  "id": "lead_id",
  "firstName": "Jane",
  "lastName": "Smith",
  "headline": "Director of Marketing at Acme Inc.",
  "industry": "Marketing and Advertising",
  "location": "San Francisco Bay Area",
  "company": {
    "id": "company_id",
    "name": "Acme Inc.",
    "industry": "Marketing and Advertising"
  },
  "email": "jane.smith@acme.com",
  "phone": "+1-555-123-4567",
  "profileUrl": "https://www.linkedin.com/in/janesmith"
}
```

### Get Company Details

```bash
curl -X GET "https://api.linkedin.com/v2/salesNavigator/companies/{company_id}" \
  -H "Authorization: Bearer {access_token}"
```

## Complete Workflow Example

```bash
# 1. Get authorization code (in browser)
# Visit: https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT&scope=r_liteprofile%20r_salesnavigatorapi

# 2. Exchange code for token
curl -X POST https://www.linkedin.com/oauth/v2/accessToken \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "code=AUTHORIZATION_CODE_FROM_STEP_1" \
  -d "redirect_uri=YOUR_REDIRECT_URI" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET"

# 3. Search for leads
curl -X GET "https://api.linkedin.com/v2/salesNavigator/leads?q=keyword&keywords=John%20Doe" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# 4. Get detailed lead info
curl -X GET "https://api.linkedin.com/v2/salesNavigator/leads/LEAD_ID" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# 5. Get company details
curl -X GET "https://api.linkedin.com/v2/salesNavigator/companies/COMPANY_ID" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Checklist Before Testing

- [ ] LinkedIn Developer App created
- [ ] Client ID and Client Secret obtained
- [ ] Redirect URI registered and configured
- [ ] API access approved by LinkedIn (contact LinkedIn sales/support)
- [ ] OAuth scopes determined (r_salesnavigatorapi at minimum)
- [ ] Test environment ready

## Notes

- Access tokens typically expire after 60 days (5184000 seconds)
- You may need to implement token refresh logic
- The actual API endpoints and scopes may vary based on your agreement with LinkedIn
- Always refer to official LinkedIn documentation for the most up-to-date information

---

*Created: January 24, 2026*
