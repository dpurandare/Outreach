# LinkedIn Sales Navigator API

## Overview
The LinkedIn Sales Navigator API allows organizations to integrate LinkedIn’s advanced sales features and data into their own applications, such as CRMs or custom sales tools. It is designed for lead discovery, account management, and syncing CRM data with LinkedIn.

## Access & Authentication
- **Access:** The API is not publicly available. Access is restricted to LinkedIn partners or organizations with special agreements.
- **Authentication:** Uses OAuth 2.0. You must register an application with LinkedIn and obtain user consent for access tokens.

## Key Features
- Search for leads and accounts
- Retrieve detailed profile and company information
- Sync CRM data with LinkedIn
- Get recommended leads and accounts

## Example: Authenticating and Making a Request

### 1. OAuth 2.0 Authentication
```http
POST https://www.linkedin.com/oauth/v2/accessToken
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&code={authorization_code}&redirect_uri={redirect_uri}&client_id={client_id}&client_secret={client_secret}
```

### 2. Example: Search for Leads by Name
```http
GET https://api.linkedin.com/v2/salesNavigator/leads?q=keyword&keywords=John%20Doe
Authorization: Bearer {access_token}
```

#### Response (example):
```json
{
  "elements": [
    {
      "id": "lead_id",
      "firstName": "John",
      "lastName": "Doe",
      "title": "VP of Sales",
      "company": "Example Corp",
      "profileUrl": "https://www.linkedin.com/in/johndoe"
    }
  ]
}
```


## Use Case: Search All Relevant Details for a Given Name
To search for all relevant details for a given name (e.g., "Jane Smith"):
1. Authenticate using OAuth 2.0 to obtain an access token.
2. Use the leads search endpoint with the name as a keyword.
3. For each result, use the lead's `id` to fetch enriched details.
4. Optionally, fetch company details using the company ID.

### Step 1: Search for Leads
```http
GET https://api.linkedin.com/v2/salesNavigator/leads?q=keyword&keywords=Jane%20Smith
Authorization: Bearer {access_token}
```

### Step 2: Get Lead Details by ID
```http
GET https://api.linkedin.com/v2/salesNavigator/leads/{lead_id}
Authorization: Bearer {access_token}
```

#### Example Lead Details Response
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

### Step 3: Get Company Details (Optional)
```http
GET https://api.linkedin.com/v2/salesNavigator/companies/{company_id}
Authorization: Bearer {access_token}
```

#### Example Company Details Response
```json
{
  "id": "company_id",
  "name": "Acme Inc.",
  "industry": "Marketing and Advertising",
  "website": "https://www.acme.com",
  "size": "201-500 employees",
  "location": "San Francisco, CA, USA"
}
```


## Creating a Detailed Information Page (Markdown)

To generate a rich, human-readable information page for a person using only their name (and optionally company):

### Workflow
1. **Search for the person** using the Sales Navigator API with their name (and company, if available).
2. **Fetch full lead details** for each matching result using the lead ID.
3. **Fetch company details** using the company ID from the lead profile.
4. **Aggregate and render** the information in Markdown format.

### Sample Markdown Template

```
# {Full Name}

**Headline:** {Headline}

**Current Title:** {Current Title}

**Company:** [{Company Name}]({Company Website})

**Industry:** {Industry}

**Location:** {Location}

**Contact Info:**
- Email: {Email}
- Phone: {Phone}

**LinkedIn Profile:** [{Profile URL}]({Profile URL})

---

## Company Details

- **Name:** {Company Name}
- **Industry:** {Company Industry}
- **Size:** {Company Size}
- **Website:** [{Company Website}]({Company Website})
- **Location:** {Company Location}

---

## Experience

| Title | Company | Duration |
|-------|---------|----------|
| {Title 1} | {Company 1} | {Duration 1} |
| {Title 2} | {Company 2} | {Duration 2} |

---

## Summary

{Summary or About Section}

```

### Notes
- Replace placeholders with actual data from the API responses.
- Add or remove sections as needed based on available data.
- You can automate this process in your application to generate a Markdown file for each person searched.

---

*This document is a summary based on public knowledge as of January 2026. For production use, you must obtain official access and documentation from LinkedIn.*
