# LinkedIn Lead Sync API - Complete Guide

## Table of Contents
1. [Overview](#overview)
2. [Lead Sync API vs Sales Navigator](#lead-sync-api-vs-sales-navigator)
3. [Use Cases](#use-cases)
4. [Prerequisites & Getting Access](#prerequisites--getting-access)
5. [Authentication](#authentication)
6. [API Endpoints](#api-endpoints)
7. [Webhooks (Real-Time Notifications)](#webhooks-real-time-notifications)
8. [End-to-End Workflow Examples](#end-to-end-workflow-examples)
9. [Testing](#testing)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

---

## Overview

The LinkedIn Lead Sync API enables developers to collect and sync leads from LinkedIn Lead Gen Forms to marketing automation platforms, CRMs, and CDPs. It supports leads from multiple sources:

| Lead Type | Source | Description |
|-----------|--------|-------------|
| `SPONSORED` | LinkedIn Ads | Leads from sponsored content campaigns |
| `EVENT` | LinkedIn Events | Event registration leads |
| `COMPANY` | Company Pages | Leads from organic company page forms |
| `ORGANIZATION_PRODUCT` | Product Pages | Leads from product page forms |

**Key Capabilities:**
- Retrieve lead gen forms and form responses
- Create and manage lead gen forms programmatically
- Register webhooks for real-time lead notifications
- Map custom form fields to your CRM schema

---

## Lead Sync API vs Sales Navigator

| Feature | Lead Sync API | Sales Navigator |
|---------|---------------|-----------------|
| **Purpose** | Capture inbound form submissions | Outbound prospect discovery |
| **Data Source** | Lead Gen Form responses | LinkedIn member profiles |
| **API Access** | Publicly available (with approval) | **No public API** |
| **Lead Type** | People who filled out YOUR forms | Any LinkedIn member |
| **Use Case** | Inbound lead management | Outbound prospecting |
| **Required Product** | Lead Sync API product | Sales Navigator subscription |

**Important:** Sales Navigator does NOT have a public API. The Lead Sync API is for capturing leads who have actively submitted their information through your LinkedIn Lead Gen Forms.

---

## Use Cases

### Use Case 1: Lead Syncing to CRM/CDP

Automatically sync leads from LinkedIn to your marketing automation platform, CRM, or CDP.

**Workflow:**
```
1. User authorizes your app (OAuth)
2. Retrieve user's ad accounts
3. Select ad account(s) for lead syncing
4. Retrieve lead gen forms from selected accounts
5. Map form fields to CRM data fields
6. Register for webhook notifications
7. Fetch existing leads via API
8. Sync new leads in real-time via webhooks
```

### Use Case 2: Lead-to-Sales Reporting

Connect lead data with sales outcomes to measure ROI.

**Workflow:**
```
1. Sync lead data with sales system
2. Track lead progression through funnel
3. Analyze lead quality vs purchases
4. Optimize campaign targeting
```

### Use Case 3: Real-Time Sales Notifications

Alert sales reps immediately when new leads are captured.

**Workflow:**
```
1. Register webhook URL
2. Receive real-time lead notifications
3. Parse lead details from payload
4. Trigger sales rep alerts
5. Enable immediate follow-up
```

---

## Prerequisites & Getting Access

### Requirements Checklist

- [ ] **LinkedIn Developer App** - Create at [developer.linkedin.com](https://developer.linkedin.com/)
- [ ] **Verified Company Page** - Real company page (no fake/test pages)
- [ ] **Business Email** - Verified business email (not personal Gmail, etc.)
- [ ] **Legal Documentation** - Organization name, registered address, website
- [ ] **LinkedIn Page Admin** - Super admin must verify your app
- [ ] **Compliant App Name** - Cannot include "Linked" or "In"

### Application Process

#### Step 1: Create Developer App
1. Go to [LinkedIn Developer Portal](https://developer.linkedin.com/)
2. Navigate to **My Apps**
3. Click **Create App**
4. Fill in app details with your verified company page

#### Step 2: Request Lead Sync API Access
1. In your app, go to **Products** tab
2. Find **Lead Sync API** in "Additional available products"
3. Click **Request Access**
4. Complete the application form
5. Wait for LinkedIn review (typically 1-5 business days)

#### Step 3: Verify Your App
LinkedIn will verify:
- Business email authenticity
- Organization legitimacy
- Website and domain ownership
- LinkedIn Page association
- Use case compliance
- Terms, security, and privacy compliance

### Required Permissions

| Permission | Description | Used For |
|------------|-------------|----------|
| `r_marketing_leadgen_automation` | Access lead forms and responses | Core lead sync functionality |
| `r_ads` | Read ad accounts and forms | Accessing sponsored lead forms |
| `rw_ads` | Manage ad accounts | Creating/updating lead forms |
| `r_organization_admin` | Access organization details | Organic lead forms |
| `r_events` | Access organization events | Event lead forms |
| `r_liteprofile` | User's basic profile | User identification |

---

## Authentication

### OAuth 2.0 Flow

#### Step 1: Authorization URL

Direct users to authorize your app:

```
https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}&scope=r_ads%20r_marketing_leadgen_automation%20r_organization_admin%20openid%20profile%20email
```

**Parameters:**
- `client_id` - Your app's client ID
- `redirect_uri` - URL-encoded redirect URI
- `scope` - Space-separated, URL-encoded scopes

#### Step 2: Exchange Code for Token

```bash
curl -X POST "https://www.linkedin.com/oauth/v2/accessToken" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code&code={AUTH_CODE}&redirect_uri={REDIRECT_URI}&client_id={CLIENT_ID}&client_secret={CLIENT_SECRET}"
```

**Note:** If your client secret contains `==`, URL-encode it as `%3D%3D`.

**Response:**
```json
{
  "access_token": "AQV8...",
  "expires_in": 5183999,
  "refresh_token": "AQW...",
  "refresh_token_expires_in": 31556951,
  "scope": "r_ads,r_marketing_leadgen_automation,r_organization_admin,openid,profile,email",
  "token_type": "Bearer"
}
```

#### Required Headers for All API Calls

```
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: application/json
LinkedIn-Version: 202601
X-Restli-Protocol-Version: 2.0.0
```

**Important:** Use the latest LinkedIn-Version (format: YYYYMM). As of January 2026, use `202601`.

---

## API Endpoints

### Base URL
```
https://api.linkedin.com/rest/
```

### 1. Lead Forms

#### Get All Lead Forms by Owner

```bash
# By Sponsored Account (for ads)
curl -X GET "https://api.linkedin.com/rest/leadForms?owner=(sponsoredAccount:urn%3Ali%3AsponsoredAccount%3A{ACCOUNT_ID})&q=owner&count=10&start=0" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"

# By Organization (for organic forms)
curl -X GET "https://api.linkedin.com/rest/leadForms?owner=(organization:urn%3Ali%3Aorganization%3A{ORG_ID})&q=owner&count=10&start=0" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

**Response:**
```json
{
  "elements": [
    {
      "id": 6083,
      "name": "Contact Us Form",
      "state": "PUBLISHED",
      "owner": {
        "sponsoredAccount": "urn:li:sponsoredAccount:507857085"
      },
      "content": {
        "headline": {"localized": {"en_US": "Contact us about our product"}},
        "description": {"localized": {"en_US": "Share your information"}},
        "questions": [...]
      }
    }
  ],
  "paging": {
    "count": 10,
    "start": 0,
    "total": 25
  }
}
```

#### Get Single Lead Form

```bash
curl -X GET "https://api.linkedin.com/rest/leadForms/{FORM_ID}" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

#### Create Lead Form

```bash
curl -X POST "https://api.linkedin.com/rest/leadForms" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0" \
  -d '{
    "owner": {
      "sponsoredAccount": "urn:li:sponsoredAccount:507857085"
    },
    "creationLocale": {
      "country": "US",
      "language": "en"
    },
    "name": "Product Interest Form",
    "state": "DRAFT",
    "content": {
      "headline": {
        "localized": {"en_US": "Learn more about our product"}
      },
      "description": {
        "localized": {"en_US": "Fill out this form and we will contact you"}
      },
      "questions": [
        {
          "question": {"localized": {"en_US": "First Name"}},
          "name": "firstName",
          "predefinedField": "FIRST_NAME",
          "questionDetails": {"textQuestionDetails": {}}
        },
        {
          "question": {"localized": {"en_US": "Last Name"}},
          "name": "lastName",
          "predefinedField": "LAST_NAME",
          "questionDetails": {"textQuestionDetails": {}}
        },
        {
          "question": {"localized": {"en_US": "Email"}},
          "name": "email",
          "predefinedField": "EMAIL",
          "questionDetails": {"textQuestionDetails": {}}
        },
        {
          "question": {"localized": {"en_US": "Company"}},
          "name": "company",
          "predefinedField": "COMPANY_NAME",
          "questionDetails": {"textQuestionDetails": {}}
        }
      ],
      "legalInfo": {
        "privacyPolicyUrl": "https://yourcompany.com/privacy",
        "consents": [
          {
            "id": 1,
            "checkRequired": false,
            "consent": {
              "localized": {"en_US": "I agree to be contacted via email"}
            }
          }
        ]
      }
    }
  }'
```

### 2. Lead Form Responses (Leads)

#### Get Leads by Owner

```bash
# Get sponsored leads
curl -X GET "https://api.linkedin.com/rest/leadFormResponses?owner=(sponsoredAccount:urn%3Ali%3AsponsoredAccount%3A{ACCOUNT_ID})&leadType=(leadType:SPONSORED)&q=owner" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"

# Get event leads
curl -X GET "https://api.linkedin.com/rest/leadFormResponses?owner=(organization:urn%3Ali%3Aorganization%3A{ORG_ID})&leadType=(leadType:EVENT)&q=owner" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

**Optional Filters:**
- `versionedLeadGenFormUrn` - Filter by specific form
- `associatedEntity` - Filter by campaign/event
- `submittedAtTimeRange` - Filter by date range (epoch timestamps)
- `limitedToTestLeads` - Set to `true` for test leads only

**Response:**
```json
{
  "elements": [
    {
      "id": "aaaabbbb-0000-cccc-1111-dddd2222eeee-5",
      "leadType": "SPONSORED",
      "owner": {
        "sponsoredAccount": "urn:li:sponsoredAccount:522529623"
      },
      "submitter": "urn:li:person:MpGcnvaU_p",
      "submittedAt": 1686182358881,
      "testLead": false,
      "leadMetadata": {
        "sponsoredLeadMetadata": {
          "campaign": "urn:li:sponsoredCampaign:367378525"
        }
      },
      "formResponse": {
        "answers": [
          {
            "questionId": 1,
            "name": "firstName",
            "accepted": {
              "textQuestionAnswer": {
                "answer": "John"
              }
            }
          },
          {
            "questionId": 2,
            "name": "lastName",
            "accepted": {
              "textQuestionAnswer": {
                "answer": "Smith"
              }
            }
          },
          {
            "questionId": 3,
            "name": "email",
            "accepted": {
              "textQuestionAnswer": {
                "answer": "john.smith@company.com"
              }
            }
          }
        ],
        "consentResponses": [
          {
            "consentId": 1,
            "accepted": true
          }
        ]
      }
    }
  ],
  "paging": {
    "count": 10,
    "start": 0,
    "total": 150
  }
}
```

#### Get Single Lead Response

```bash
curl -X GET "https://api.linkedin.com/rest/leadFormResponses/{RESPONSE_ID}" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

### 3. Ad Accounts

#### Get All Ad Accounts

```bash
curl -X GET "https://api.linkedin.com/v2/adAccountsV2?q=search" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

**Response:**
```json
{
  "elements": [
    {
      "id": 507857085,
      "name": "My Company Ads",
      "status": "ACTIVE",
      "type": "BUSINESS"
    }
  ],
  "paging": {
    "count": 1000,
    "start": 0,
    "total": 1
  }
}
```

### 4. Organizations

#### Get Organizations Where User is Admin

```bash
curl -X GET "https://api.linkedin.com/v2/organizationAcls?q=roleAssignee&role=ADMINISTRATOR" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202401" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

---

## Webhooks (Real-Time Notifications)

### Overview

Register webhooks to receive real-time notifications when leads are created or deleted. Only HTTPS URLs are supported.

### Register Webhook

#### Owner-Level Subscription (All Forms)

```bash
curl -X POST "https://api.linkedin.com/rest/leadNotifications" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0" \
  -d '{
    "webhook": "https://yourdomain.com/linkedin/webhook",
    "owner": {
      "sponsoredAccount": "urn:li:sponsoredAccount:520866471"
    },
    "leadType": "SPONSORED"
  }'
```

#### Form-Level Subscription (Specific Form)

```bash
curl -X POST "https://api.linkedin.com/rest/leadNotifications" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0" \
  -d '{
    "webhook": "https://yourdomain.com/linkedin/webhook",
    "owner": {
      "organization": "urn:li:organization:12345"
    },
    "versionedForm": "urn:li:versionedLeadGenForm:(urn:li:leadGenForm:818,1)",
    "leadType": "EVENT"
  }'
```

### Webhook Payload Examples

#### Lead Created
```json
{
  "type": "LEAD_ACTION",
  "leadGenFormResponse": "urn:li:leadGenFormResponse:1a2b3c-4",
  "leadGenForm": "urn:li:versionedLeadGenForm:(urn:li:leadGenForm:1, 1)",
  "owner": {
    "sponsoredAccount": "urn:li:sponsoredAccount:123"
  },
  "associatedEntity": {
    "sponsoredCreative": "urn:li:sponsoredCreative:456"
  },
  "leadType": "SPONSORED",
  "leadAction": "CREATED",
  "occurredAt": 1686182358881
}
```

#### Lead Deleted
```json
{
  "type": "LEAD_ACTION",
  "leadGenFormResponse": "urn:li:leadGenFormResponse:1a2b3c-4",
  "leadGenForm": "urn:li:versionedLeadGenForm:(urn:li:leadGenForm:1, 1)",
  "owner": {
    "organization": "urn:li:organization:123"
  },
  "associatedEntity": {
    "event": "urn:li:event:789"
  },
  "leadType": "EVENT",
  "leadAction": "DELETED",
  "occurredAt": 1686182358881
}
```

### Get Existing Subscriptions

```bash
curl -X GET "https://api.linkedin.com/rest/leadNotifications?q=criteria&owner=(value:(sponsoredAccount:urn%3Ali%3AsponsoredAccount%3A511849581))&leadType=(leadType:SPONSORED)" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

### Delete Subscription

```bash
curl -X DELETE "https://api.linkedin.com/rest/leadNotifications/{SUBSCRIPTION_ID}" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

---

## End-to-End Workflow Examples

### Example 1: Sync Sponsored Ad Leads to CRM

```bash
#!/bin/bash

# Configuration
ACCESS_TOKEN="your_access_token"
SPONSORED_ACCOUNT_ID="507857085"
VERSION="202601"

# Step 1: Get all lead forms for the ad account
echo "=== Fetching Lead Forms ==="
curl -s -X GET "https://api.linkedin.com/rest/leadForms?owner=(sponsoredAccount:urn%3Ali%3AsponsoredAccount%3A${SPONSORED_ACCOUNT_ID})&q=owner" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "LinkedIn-Version: ${VERSION}" \
  -H "X-Restli-Protocol-Version: 2.0.0" | jq '.'

# Step 2: Fetch leads from the last 7 days
echo "=== Fetching Leads (Last 7 Days) ==="
START_TIME=$(($(date +%s) - 604800))000  # 7 days ago in milliseconds
END_TIME=$(date +%s)000  # Now in milliseconds

curl -s -X GET "https://api.linkedin.com/rest/leadFormResponses?owner=(sponsoredAccount:urn%3Ali%3AsponsoredAccount%3A${SPONSORED_ACCOUNT_ID})&leadType=(leadType:SPONSORED)&q=owner&submittedAtTimeRange=(start:${START_TIME},end:${END_TIME})" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "LinkedIn-Version: ${VERSION}" \
  -H "X-Restli-Protocol-Version: 2.0.0" | jq '.'

# Step 3: Register webhook for real-time notifications
echo "=== Registering Webhook ==="
curl -s -X POST "https://api.linkedin.com/rest/leadNotifications" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "LinkedIn-Version: ${VERSION}" \
  -H "X-Restli-Protocol-Version: 2.0.0" \
  -d "{
    \"webhook\": \"https://yourdomain.com/linkedin/leads\",
    \"owner\": {
      \"sponsoredAccount\": \"urn:li:sponsoredAccount:${SPONSORED_ACCOUNT_ID}\"
    },
    \"leadType\": \"SPONSORED\"
  }" | jq '.'
```

### Example 2: Event Lead Collection

```bash
#!/bin/bash

# Configuration
ACCESS_TOKEN="your_access_token"
ORG_ID="12345678"
VERSION="202601"

# Step 1: Get event lead forms
echo "=== Fetching Event Lead Forms ==="
curl -s -X GET "https://api.linkedin.com/rest/leadForms?owner=(organization:urn%3Ali%3Aorganization%3A${ORG_ID})&q=owner" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "LinkedIn-Version: ${VERSION}" \
  -H "X-Restli-Protocol-Version: 2.0.0" | jq '.'

# Step 2: Fetch event leads
echo "=== Fetching Event Leads ==="
curl -s -X GET "https://api.linkedin.com/rest/leadFormResponses?owner=(organization:urn%3Ali%3Aorganization%3A${ORG_ID})&leadType=(leadType:EVENT)&q=owner" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "LinkedIn-Version: ${VERSION}" \
  -H "X-Restli-Protocol-Version: 2.0.0" | jq '.'
```

### Example 3: Python Script for Lead Processing

```python
import requests
import json
from datetime import datetime, timedelta

class LinkedInLeadSync:
    def __init__(self, access_token, account_id, account_type='sponsoredAccount'):
        self.access_token = access_token
        self.account_id = account_id
        self.account_type = account_type
        self.base_url = "https://api.linkedin.com/rest"
        self.headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json",
            "LinkedIn-Version": "202601",
            "X-Restli-Protocol-Version": "2.0.0"
        }

    def get_lead_forms(self):
        """Fetch all lead forms for the account"""
        owner_urn = f"urn:li:{self.account_type}:{self.account_id}"
        url = f"{self.base_url}/leadForms?owner=({self.account_type}:{owner_urn})&q=owner"
        response = requests.get(url, headers=self.headers)
        return response.json()

    def get_leads(self, lead_type="SPONSORED", days_back=7):
        """Fetch leads from the specified time range"""
        owner_urn = f"urn:li:{self.account_type}:{self.account_id}"

        # Calculate time range
        end_time = int(datetime.now().timestamp() * 1000)
        start_time = int((datetime.now() - timedelta(days=days_back)).timestamp() * 1000)

        url = (f"{self.base_url}/leadFormResponses?"
               f"owner=({self.account_type}:{owner_urn})&"
               f"leadType=(leadType:{lead_type})&q=owner&"
               f"submittedAtTimeRange=(start:{start_time},end:{end_time})")

        response = requests.get(url, headers=self.headers)
        return response.json()

    def parse_lead_response(self, lead):
        """Parse a lead response into a flat dictionary"""
        parsed = {
            "id": lead.get("id"),
            "submittedAt": datetime.fromtimestamp(lead.get("submittedAt", 0) / 1000),
            "testLead": lead.get("testLead", False),
            "leadType": lead.get("leadType")
        }

        # Parse form answers
        for answer in lead.get("formResponse", {}).get("answers", []):
            field_name = answer.get("name")
            if "textQuestionAnswer" in answer.get("accepted", {}):
                parsed[field_name] = answer["accepted"]["textQuestionAnswer"]["answer"]
            elif "multipleChoiceAnswer" in answer.get("accepted", {}):
                parsed[field_name] = answer["accepted"]["multipleChoiceAnswer"]["options"]

        return parsed

    def register_webhook(self, webhook_url, lead_type="SPONSORED"):
        """Register a webhook for lead notifications"""
        url = f"{self.base_url}/leadNotifications"
        payload = {
            "webhook": webhook_url,
            "owner": {
                self.account_type: f"urn:li:{self.account_type}:{self.account_id}"
            },
            "leadType": lead_type
        }
        response = requests.post(url, headers=self.headers, json=payload)
        return response.json()

# Usage Example
if __name__ == "__main__":
    # Initialize client
    client = LinkedInLeadSync(
        access_token="YOUR_ACCESS_TOKEN",
        account_id="507857085",
        account_type="sponsoredAccount"
    )

    # Fetch lead forms
    forms = client.get_lead_forms()
    print(f"Found {len(forms.get('elements', []))} lead forms")

    # Fetch leads from last 7 days
    leads_response = client.get_leads(days_back=7)
    leads = leads_response.get("elements", [])
    print(f"Found {len(leads)} leads")

    # Parse and display leads
    for lead in leads:
        parsed = client.parse_lead_response(lead)
        print(f"Lead: {parsed.get('firstName')} {parsed.get('lastName')} - {parsed.get('email')}")

    # Register webhook (uncomment to use)
    # result = client.register_webhook("https://yourdomain.com/linkedin/webhook")
    # print(f"Webhook registered: {result}")
```

---

## Testing

### Generate Test Leads

1. Go to [LinkedIn Campaign Manager](https://www.linkedin.com/campaignmanager/)
2. Select your ad account
3. Navigate to your campaign with a Lead Gen Form
4. Click on the Lead Gen Form
5. Use the "Generate Test Lead" feature
6. Fill out the form with test data

### Retrieve Test Leads via API

```bash
curl -X GET "https://api.linkedin.com/rest/leadFormResponses?owner=(sponsoredAccount:urn%3Ali%3AsponsoredAccount%3A{ACCOUNT_ID})&leadType=(leadType:SPONSORED)&q=owner&limitedToTestLeads=true" \
  -H "Authorization: Bearer {TOKEN}" \
  -H "LinkedIn-Version: 202601" \
  -H "X-Restli-Protocol-Version: 2.0.0"
```

Test leads will have `"testLead": true` in the response.

---

## Best Practices

### Push vs Pull Strategy

| Method | When to Use | Pros | Cons |
|--------|-------------|------|------|
| **Push (Webhooks)** | Real-time lead processing | Immediate delivery, no polling | Requires HTTPS endpoint |
| **Pull (Polling)** | Batch processing, backup | Simple implementation | Delayed, resource-intensive |
| **Hybrid** | Production systems | Best of both worlds | More complex |

**Recommendation:** Use webhooks for real-time notifications with periodic polling as a backup to catch any missed leads.

### Rate Limiting

- Implement exponential backoff for retries
- Cache responses where appropriate
- Use pagination for large result sets

### Error Handling

```python
def handle_api_error(response):
    if response.status_code == 401:
        # Token expired - refresh and retry
        pass
    elif response.status_code == 403:
        # Permission denied - check scopes
        pass
    elif response.status_code == 404:
        # Resource not found - check URNs
        pass
    elif response.status_code == 426:
        # Version not supported - update LinkedIn-Version header
        pass
    elif response.status_code == 429:
        # Rate limited - implement backoff
        pass
```

### Security

- Store access tokens securely (never in code)
- Use HTTPS for all webhook URLs
- Validate webhook payloads
- Implement token refresh before expiration

---

## Troubleshooting

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `EMPTY_ACCESS_TOKEN` | Token not properly passed | Check Authorization header format |
| `INVALID_CLIENT` | Wrong client credentials | Verify client_id and client_secret |
| `NONEXISTENT_VERSION` | Invalid LinkedIn-Version | Use current version (e.g., 202601) |
| `RESOURCE_NOT_FOUND` | Missing owner/form | Ensure you have ad accounts or org admin access |
| `ILLEGAL_ARGUMENT` | Invalid URN format | URL-encode URNs properly |
| `Parameter 'owner' is required` | Missing owner parameter | Add owner parameter to request |

### Finding Your IDs

**Organization ID:**
1. Go to your LinkedIn Company Page
2. Check URL: `linkedin.com/company/12345678/`
3. The number is your Organization ID

**Sponsored Account ID:**
1. Go to [Campaign Manager](https://www.linkedin.com/campaignmanager/)
2. Check URL: `linkedin.com/campaignmanager/accounts/507857085/`
3. The number is your Sponsored Account ID

### API Version

Always use the latest supported version. As of January 2026:
- Use `LinkedIn-Version: 202601`
- Check [LinkedIn API documentation](https://learn.microsoft.com/en-us/linkedin/marketing/) for updates

---

## Resources

- [Official Lead Sync Documentation](https://learn.microsoft.com/en-us/linkedin/marketing/lead-sync/leadsync)
- [Getting Access to Lead Sync API](https://learn.microsoft.com/en-us/linkedin/marketing/lead-sync/getting-access-leadsync)
- [API Migration Guide](https://learn.microsoft.com/en-us/linkedin/marketing/lead-sync/lead-sync-api-migration-guide)
- [Postman Collection](https://www.postman.com/linkedin-developer-apis/linkedin-marketing-solutions-versioned-apis/documentation/9ytut4u/lead-sync)
- [LinkedIn Developer Portal](https://developer.linkedin.com/)
- [LinkedIn Developer Support](https://linkedin.zendesk.com/hc/en-us)

---

*Last Updated: January 30, 2026*
