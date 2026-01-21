# Zoho CRM API Requirements & Availability (B2B Outreach System)

## CRM Building Blocks (per Zoho CRM basics)
- **Leads**: unqualified people you have contact info for (imports, forms, events). You work them until you know if they are real opportunities.
- **Contacts**: qualified people you expect to interact with; typically created by converting Leads after a sale/qualification moment.
- **Accounts**: the companies/organizations your Contacts belong to; a single Account can have many Contacts.
- **Deals**: sales opportunities with value and stage; each Deal ties to a Contact and its Account so pipeline totals roll up logically.
- **Typical flow**: Capture as Lead → qualify → convert to Contact + Account (optional immediate Deal) → advance Deal stages.

Scope: cover only what we need to automate the outreach system (ingest from Apollo/Sales Nav, scoring, segmentation, sync to GoHighLevel, tracking). All endpoints are Zoho CRM REST API v2 unless noted. Auth is OAuth 2.0 (server-based flow). Base URL: `https://www.zohoapis.com/crm/v2` (EU/IN have region-specific domains).

## Authentication & Org Setup
- OAuth 2.0 (authorization code) → access + refresh tokens **(available)**
- Token refresh endpoint **(available)**
- Org/portal details endpoint **(available)** to confirm domain and DC

## Data Ingestion (Accounts/Contacts/Leads)
- Bulk upsert Leads/Contacts/Accounts via `bulk/v2/write` + job callbacks **(available)**
- Upsert single/batch via `/{module}/upsert` (supports external ID) **(available)**
- Create/Update/Delete batch records `/{module}` (Leads, Contacts, Accounts) **(available)**
- Convert Lead → Contact/Account/Deal via `Leads/{id}/actions/convert` **(available)**
- Search records via `/{module}/search` (email/phone/custom criteria) **(available)**
- Duplicate check by `upsert` with `duplicate_check_fields` or `search` then merge **(available)**
- Attachments upload/download `/{module}/{id}/Attachments` **(available)**
- File uploads for bulk imports (async) **(available)**

## Segmentation, Tagging, Custom Fields
- Add/remove Tags `/{module}/{id}/actions/add_tags` / `remove_tags` **(available)**
- Get/define Custom Fields `settings/fields?module=Leads|Contacts|Accounts|Deals` **(available)**
- Layouts & sections `settings/layouts` (to ensure required fields) **(available)**
- Picklists / multi-select values retrieval (in settings/fields response) **(available)**

## Scoring & Qualification
- Update numeric scoring fields (Account Fit, Persona Influence, Engagement) via record update **(available)**
- Custom functions invocation `functions/{func_name}/actions/execute` (to encapsulate scoring logic inside Zoho) **(available)**
- Workflows & scoring rules configuration via UI only (no public REST create/update) → we can **trigger** scoring by writing to fields or calling custom functions **(partially available)**

## Activities & Notes
- Tasks/Calls/Events CRUD `Tasks`, `Calls`, `Events` modules **(available)**
- Notes CRUD `Notes` related list on any record **(available)**
- Attachments to Notes/Records **(available)**

## Deals/Pipeline Tracking
- Deals CRUD `Deals` module **(available)**
- Stage updates (pipeline progression) via Deals update **(available)**
- Products/Price Books (not mandatory for MVP) **(available)**

## Reporting & Analytics
- Reports API `reports/{id}` (read-only export of defined reports) **(available)**
- Dashboards API is not exposed; need to recreate via Reports or external BI **(not available)**

## Webhooks, Integration Triggers
- Coql (SQL-like) query `coql` for complex reads (batch) **(available)**
- Webhooks must be configured in UI; no public REST to create/update webhooks **(not available)**
- Functions API (invoke) can push to GoHighLevel/other systems **(available)**

## Email & Communication (decide case-by-case)
- Sending email from Zoho CRM records `Emails/actions/send` **(available)** but we plan outreach via GoHighLevel; keep disabled to avoid conflict
- Email insights (opens/clicks) only for emails sent via Zoho **(available if using Zoho mail add-on)**

## Rate Limits & Practical Notes
- Org-level limits vary by edition; standard is ~100 requests/min & 250k/day for paid; trials have lower caps → design batching (bulk write/read) and backoff **(available with limits)**
- Bulk write supports up to 25k records/job; bulk read up to 200k/job **(available)**
- Sandbox: Zoho offers a sandbox; APIs use same endpoints with sandbox org **(available on paid editions)**

## Minimal API Set for Our Use Cases
1) **Ingest & Deduplicate**: `bulk/v2/write`, `Leads|Contacts|Accounts/upsert`, `search`, `coql`
2) **Enrichment Merge**: `search` by email/phone, `upsert` with `duplicate_check_fields`, `Attachments`
3) **Scoring**: record update of scoring fields; optional `functions/{name}/actions/execute`
4) **Segmentation**: `add_tags` / `remove_tags`; custom field updates
5) **Activity Logging**: `Notes`, `Tasks`, `Calls`, `Events` modules
6) **Pipeline**: `Deals` CRUD + stage update
7) **Reporting Export**: `reports/{id}` if we need external dashboards
8) **Outbound Hooks**: call custom Function that forwards to GoHighLevel/webhook

## Gaps / Workarounds
- Webhook creation & workflow rules cannot be scripted via public REST → set once in UI, then consume via our endpoints
- Scoring Rules UI not exposed; implement scoring via custom functions or external service writing back scores
- Dashboard objects not readable via API; use Reports API or external BI for metrics

## Quick Availability Checklist
- OAuth2 auth/refresh: **Yes**
- Leads/Contacts/Accounts CRUD + upsert + bulk: **Yes**
- Lead convert: **Yes**
- Search/Coql: **Yes**
- Tags: **Yes**
- Custom fields/layouts metadata: **Yes**
- Notes/Attachments/Tasks/Events/Calls: **Yes**
- Deals pipeline: **Yes**
- Reports export: **Yes**
- Webhook create/update via API: **No (UI only)**
- Workflow/scoring rule create/update via API: **No (UI only)**
- Dashboards via API: **No (use Reports)**
- Email send via API: **Yes (optional, not primary path)**
