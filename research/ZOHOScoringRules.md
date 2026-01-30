# Zoho CRM Scoring Rules Implementation Guide

## Overview

This document outlines how to implement the B2B Outreach System scoring mechanism (defined in Outreach.md) using Zoho CRM's scoring rules facility. The goal is to calculate a **Total Outreach Priority Score** for each prospect to prioritize high-value accounts.

## Scoring Formula from Requirements

```
Total Outreach Priority Score = Account Fit Score + Persona Influence Score + Engagement Score
```

- **Account Fit Score**: 0-100 points
- **Persona Influence Score**: 0-50 points
- **Engagement Score**: Rolling points based on interactions
- **Action Threshold**: Prospects above 110 move to high-touch personalization

---

## Zoho CRM Scoring Capabilities

Zoho CRM offers two types of scoring systems:

### 1. Rule-Based Scoring (Manual)
- Define explicit rules based on field values, behaviors, and touchpoints
- Points range: -100 to +100 per rule
- Supports: Leads, Contacts, Accounts, Deals, Custom Modules
- Best for: Transparent, explainable scoring with known criteria

### 2. Zia Predictive Scoring (AI-Powered)
- Uses machine learning to analyze historical conversion patterns
- Scores shown as percentages (0-100%)
- Requires minimum historical data for training
- Best for: Data-driven insights when you have sufficient historical data

**Recommendation**: Start with **Rule-Based Scoring** for full control and transparency, then supplement with Zia predictions for refinement.

---

## Implementation Strategy

Since Zoho CRM scoring rules work at the module level (Leads, Contacts, Accounts), we need to implement scoring across multiple modules to capture the complete picture.

### Module Strategy

| Score Component | Module | Why |
|----------------|--------|-----|
| Account Fit Score | **Accounts** | Company-level characteristics (industry, size, assets, tech stack) |
| Persona Influence Score | **Contacts** | Individual-level signals (role, tenure, activity, connections) |
| Engagement Score | **Contacts** | Interaction tracking (emails, LinkedIn, meetings) |

**Note**: Zoho CRM allows multiple scoring rules per module, so you can create separate scoring rules for each component and display all scores together.

---

## Implementation: Account Fit Score (0-100)

### Setup Location
**Navigation**: Settings → Automation → Scoring Rules → New Scoring Rule

### Configuration

**Rule Name**: Account Fit Score
**Module**: Accounts
**Layout**: All (or specific layout for JBS prospects)

### Scoring Criteria

#### 1. Industry Fit (25 points max)

| Condition | Points |
|-----------|--------|
| Industry = "Utilities" | +25 |
| Industry = "Renewable Energy" | +25 |
| Industry = "Energy Trading" | +25 |
| Industry = "Independent Power Producer (IPP)" | +25 |
| Industry = "Oil & Gas" | +15 |
| Industry = "Manufacturing (Energy-intensive)" | +10 |
| Industry = Other | 0 |

**Implementation**: Use field rule on "Industry" field with multiple OR conditions.

#### 2. Asset Scale (20 points max)

| Condition | Points |
|-----------|--------|
| Annual Revenue > $500M | +20 |
| Annual Revenue $100M-$500M | +15 |
| Annual Revenue $50M-$100M | +10 |
| Annual Revenue < $50M | +5 |
| Number of Employees 5,000-10,000 | +15 |
| Number of Employees 1,000-5,000 | +10 |
| Number of Employees 500-1,000 | +5 |

**Custom Fields Needed**:
- `Asset_Scale_MW` (Number) - Megawatts of generation capacity
- `Number_of_Sites` (Number) - Physical locations/assets

| Condition | Points |
|-----------|--------|
| Asset_Scale_MW > 1000 | +20 |
| Asset_Scale_MW 500-1000 | +15 |
| Asset_Scale_MW 100-500 | +10 |
| Number_of_Sites > 50 | +10 |
| Number_of_Sites 20-50 | +5 |

#### 3. Data Complexity (20 points max)

**Custom Fields Needed**:
- `Data_Sources` (Multi-select) - SCADA, IoT, Trading, Weather, etc.
- `Data_Volume_TB` (Number)
- `Uses_Multiple_Systems` (Checkbox)

| Condition | Points |
|-----------|--------|
| Data_Sources contains "SCADA" AND "IoT" | +10 |
| Data_Sources contains "Trading Data" | +5 |
| Data_Volume_TB > 10 | +10 |
| Data_Volume_TB 1-10 | +5 |
| Uses_Multiple_Systems = True | +10 |

#### 4. Tech Maturity (15 points max)

**Custom Fields Needed**:
- `Tech_Stack` (Multi-select) - Azure, AWS, Databricks, Snowflake, etc.
- `Digital_Transformation_Stage` (Picklist) - Early, Developing, Advanced

| Condition | Points |
|-----------|--------|
| Tech_Stack contains "Azure" OR "AWS" | +5 |
| Tech_Stack contains "Databricks" | +5 |
| Tech_Stack contains "Snowflake" OR "Data Lake" | +3 |
| Digital_Transformation_Stage = "Advanced" | +10 |
| Digital_Transformation_Stage = "Developing" | +5 |
| Digital_Transformation_Stage = "Early" | +2 |

#### 5. Geography Priority (10 points max)

| Condition | Points |
|-----------|--------|
| Billing Country = "United States" | +10 |
| Billing Country = "United Kingdom" | +8 |
| Billing Country = "Germany" | +8 |
| Billing Country = "Australia" | +6 |
| Billing Country = Other priority markets | +3 |

#### 6. Strategic Alignment to JBS (10 points max)

**Custom Field Needed**:
- `Primary_Hero_Bet` (Picklist) - Generation Forecasting, Sales Quote Automation, Fieldforce CoPilot, Energy Data Hub, DataOps
- `Pain_Points` (Multi-select) - Forecast Accuracy, Manual Processes, Data Silos, etc.

| Condition | Points |
|-----------|--------|
| Primary_Hero_Bet is not empty | +5 |
| Pain_Points contains "Forecast Accuracy" | +5 |
| Pain_Points contains "Data Silos" | +5 |
| Pain_Points contains "Manual Quoting" | +5 |
| Pain_Points contains "Field Inefficiency" | +5 |

**Note**: Since multiple conditions can apply, implement top priorities first and cap total at 10.

---

## Implementation: Persona Influence Score (0-50)

### Setup Location
**Navigation**: Settings → Automation → Scoring Rules → New Scoring Rule

### Configuration

**Rule Name**: Persona Influence Score
**Module**: Contacts
**Layout**: All

### Scoring Criteria

#### Decision-Making Authority (20 points max)

**Custom Field Needed**:
- `Decision_Authority` (Picklist) - Decision Maker, Influencer, End User, Gatekeeper

| Condition | Points |
|-----------|--------|
| Decision_Authority = "Decision Maker" | +20 |
| Title contains "VP" OR "Vice President" | +15 |
| Title contains "Director" | +12 |
| Title contains "Head of" | +15 |
| Title contains "Chief" (CTO, CDO, COO) | +20 |
| Title contains "Manager" | +8 |

#### Budget Owner (10 points max)

**Custom Field Needed**:
- `Budget_Owner` (Checkbox)
- `Budget_Authority` (Picklist) - Full, Partial, None

| Condition | Points |
|-----------|--------|
| Budget_Owner = True | +10 |
| Budget_Authority = "Full" | +10 |
| Budget_Authority = "Partial" | +5 |
| Department = "Finance" OR "Procurement" | +5 |

#### Recent Role Change (10 points max)

**Custom Field Needed**:
- `Role_Start_Date` (Date)
- `Days_in_Role` (Formula field) - Calculate from Role_Start_Date

| Condition | Points |
|-----------|--------|
| Days_in_Role < 90 | +10 |
| Days_in_Role 90-180 | +8 |
| Days_in_Role 180-365 | +5 |
| Role_Start_Date is in last 12 months | +10 |

**Note**: Use Zoho CRM's date-based criteria or workflow to calculate this.

#### Active on LinkedIn (5 points max)

**Custom Field Needed**:
- `LinkedIn_Activity_Level` (Picklist) - Very Active, Active, Occasional, Inactive
- `LinkedIn_Posts_30_Days` (Number)

| Condition | Points |
|-----------|--------|
| LinkedIn_Activity_Level = "Very Active" | +5 |
| LinkedIn_Activity_Level = "Active" | +3 |
| LinkedIn_Posts_30_Days > 4 | +5 |

**Note**: This data needs to be enriched from Apollo.io or manually updated based on LinkedIn research.

#### Shared Connections/Groups (5 points max)

**Custom Field Needed**:
- `Shared_LinkedIn_Connections` (Number)
- `Shared_LinkedIn_Groups` (Multi-select)

| Condition | Points |
|-----------|--------|
| Shared_LinkedIn_Connections > 5 | +5 |
| Shared_LinkedIn_Connections 1-5 | +3 |
| Shared_LinkedIn_Groups is not empty | +2 |

---

## Implementation: Engagement Score (Rolling)

### Setup Location
**Navigation**: Settings → Automation → Scoring Rules → New Scoring Rule

### Configuration

**Rule Name**: Engagement Score
**Module**: Contacts
**Layout**: All

### Signal-Based Scoring

Zoho CRM supports **Signal Rules** for touchpoint tracking. These automatically track interactions and add/subtract points.

#### Email Engagement

| Signal | Points |
|--------|--------|
| Email Opened | +5 |
| Email Clicked | +10 |
| Email Replied | +20 |
| Email Bounced | -10 |
| Email Unsubscribed | -50 |

**Setup**: In scoring rule, add "Signal Rules" → Select "Email" → Set points for each action.

#### LinkedIn Engagement

**Custom Activities Needed**:
- Create custom activity types: "LinkedIn Profile View", "LinkedIn Connection Request", "LinkedIn Message"

**Zoho CRM Limitation**: LinkedIn signals are not natively supported, so you'll need to:
1. Track LinkedIn actions in Activities
2. Use Workflows to update a custom field "LinkedIn_Engagement_Points"
3. Create field rule based on LinkedIn_Engagement_Points value

| Action | Points |
|--------|--------|
| LinkedIn Profile View | +10 |
| LinkedIn Connection Accepted | +15 |
| LinkedIn Message Reply | +25 |
| LinkedIn Content Click | +10 |

#### Content & Website Engagement

| Signal | Points |
|--------|--------|
| Website Visit (via Zoho SalesIQ integration) | +5 |
| Content Download (whitepaper, case study) | +15 |
| Webinar Registration | +10 |
| Webinar Attendance | +20 |

**Setup**: If using Zoho Marketing Automation or SalesIQ, these signals can be automatically tracked.

#### Meeting Activities

| Signal | Points |
|--------|--------|
| Meeting Booked | +50 |
| Meeting Attended | +50 |
| Meeting No-Show | -20 |
| Follow-up Call Completed | +15 |

**Setup**: Use Activities module signals or workflow automation to update engagement score.

---

## Configuring Time Decay (Half-Life)

One of Zoho CRM's powerful features is **time-based score decay**. This prevents old, disengaged leads from maintaining high scores.

### Configuration

**Navigation**: In your scoring rule → Enable "Score Decay"

**Settings**:
- **Decay Method**: Half-life
- **Half-Life Period**: 30-60 days (recommended: 45 days)
- **Minimum Score**: 0 (scores won't go negative)

**How It Works**:
- If a Contact has 60 engagement points but hasn't interacted in 45 days, their engagement score drops to 30
- After another 45 days of inactivity, it drops to 15
- This ensures only actively engaged prospects maintain high priority

---

## Creating the Total Outreach Priority Score

Since Zoho CRM doesn't automatically sum scores across modules, you have two options:

### Option 1: Formula Field (Recommended)

Create a custom formula field on the **Contacts** module:

**Field Name**: Total_Outreach_Priority_Score
**Type**: Formula (Number)
**Formula**:
```
Account.Account_Fit_Score + Persona_Influence_Score + Engagement_Score
```

This will automatically calculate and display the total score.

### Option 2: Workflow Automation

Create a workflow that triggers on Contact update:

**Trigger**: When Contact is created or edited
**Action**: Field Update
- Update field: `Total_Outreach_Priority_Score`
- Value: `${Account.Account_Fit_Score} + ${Persona_Influence_Score} + ${Engagement_Score}`

---

## Implementation Workflow

### Step 1: Prepare Custom Fields

Create these custom fields in Zoho CRM:

**In Accounts Module**:
- Asset_Scale_MW (Number)
- Number_of_Sites (Number)
- Data_Sources (Multi-select)
- Data_Volume_TB (Number)
- Uses_Multiple_Systems (Checkbox)
- Tech_Stack (Multi-select)
- Digital_Transformation_Stage (Picklist)
- Primary_Hero_Bet (Picklist)
- Pain_Points (Multi-select)

**In Contacts Module**:
- Decision_Authority (Picklist)
- Budget_Owner (Checkbox)
- Budget_Authority (Picklist)
- Role_Start_Date (Date)
- Days_in_Role (Formula: TODAY() - Role_Start_Date)
- LinkedIn_Activity_Level (Picklist)
- LinkedIn_Posts_30_Days (Number)
- Shared_LinkedIn_Connections (Number)
- Shared_LinkedIn_Groups (Multi-select)
- LinkedIn_Engagement_Points (Number)
- Total_Outreach_Priority_Score (Formula or Number)

### Step 2: Create Scoring Rules

1. **Account Fit Score Rule**
   - Module: Accounts
   - Add all field-based criteria from Section 3
   - Test with sample account data

2. **Persona Influence Score Rule**
   - Module: Contacts
   - Add all field-based criteria from Section 4
   - Test with sample contact data

3. **Engagement Score Rule**
   - Module: Contacts
   - Add signal rules for email, activities, meetings
   - Configure time decay (45-day half-life)
   - Test with sample engagement data

### Step 3: Configure Score Display

1. In Contacts module layout, add fields:
   - Account.Account_Fit_Score (from related Account)
   - Persona_Influence_Score
   - Engagement_Score
   - Total_Outreach_Priority_Score

2. Create a Custom View: "High Priority Prospects"
   - Filter: Total_Outreach_Priority_Score > 110
   - Sort by: Total_Outreach_Priority_Score (descending)

### Step 4: Update Existing Records

When you save each scoring rule, Zoho will prompt:
- "Do you want to update existing records?"
- Select **Yes** to retroactively score all current Accounts/Contacts

**Warning**: This can take time for large databases (10,000+ records).

### Step 5: Create Automation for High-Score Triggers

**Workflow**: High Priority Prospect Alert

**Trigger**: When Contact updated
**Condition**: Total_Outreach_Priority_Score > 110
**Actions**:
1. Send notification to sales rep
2. Add to "High Touch Personalization" campaign in GoHighLevel
3. Update Contact Status to "Priority"
4. Create follow-up task

---

## Dashboard & Reporting

### Recommended Reports

1. **Outreach Score Distribution**
   - Chart: Histogram of Total_Outreach_Priority_Score
   - Buckets: 0-50, 51-80, 81-110, 111-150, 150+

2. **Hero Bet Conversion Rates**
   - Group by: Account.Primary_Hero_Bet
   - Metrics: Avg Score, Conversion Rate, Pipeline Value

3. **Persona Response Heatmap**
   - X-axis: Decision_Authority
   - Y-axis: Engagement_Score
   - Color: Conversion Rate

4. **Time-to-First-Meeting**
   - Filter: Contacts with Meeting Booked
   - Metric: Days from first touch to meeting
   - Group by: Score Range

### Dashboard Widgets

Create a custom dashboard with:
- Total prospects by score range (pie chart)
- Top 10 highest-scoring prospects (table)
- Score trend over time (line chart)
- Engagement activity summary (bar chart)

---

## Best Practices

### 1. Start Simple, Then Refine
- Begin with 3-5 key criteria per score component
- Launch, observe for 2-4 weeks
- Refine weights based on actual conversion data

### 2. Regular Score Audits
- Monthly: Review score distribution
- Quarterly: Adjust weights based on what's converting
- Identify "false positives" (high score, low conversion)
- Identify "false negatives" (low score, high conversion)

### 3. Data Quality is Critical
- Garbage in = garbage out
- Ensure Apollo.io enrichment is accurate
- Manually verify high-score accounts
- Use Zoho's duplicate detection

### 4. Don't Over-Automate
- Scores guide, not decide
- Always allow manual override
- Sales reps can adjust scores with custom "Manual Adjustment" field

### 5. Integration with GoHighLevel
- Use Zapier or Zoho Flow to sync high-priority contacts to GHL
- Trigger condition: Total_Outreach_Priority_Score > 110
- This ensures your outreach cadences target the right prospects

### 6. Test and Validate
- Create test Accounts and Contacts with known characteristics
- Verify scores calculate correctly
- Document expected scores for different prospect profiles

---

## Troubleshooting

### Issue: Scores Not Calculating

**Cause**: Scoring rule not active or module mismatch
**Solution**:
- Check that scoring rule is "Active"
- Verify module and layout settings
- Re-save the record to trigger recalculation

### Issue: Scores Too High/Low

**Cause**: Weight miscalibration
**Solution**:
- Review criteria and adjust point values
- Remember: Total should realistically max around 200
- Use Score Distribution report to identify outliers

### Issue: Old Contacts Keep High Scores

**Cause**: Time decay not enabled
**Solution**:
- Enable half-life decay on Engagement Score rule
- Set appropriate decay period (30-60 days)

### Issue: Multiple Scoring Rules Conflicting

**Cause**: Overlapping criteria in different rules
**Solution**:
- Each score component should have distinct, non-overlapping criteria
- Use clear naming conventions
- Document what each rule measures

---

## Advanced: Adding Zia Predictive Scoring

Once you have 3-6 months of data with your rule-based scoring:

### Step 1: Enable Zia Predictions

**Navigation**: Settings → Zia → Predictions → Enable

### Step 2: Configure Prediction Model

- **Module**: Contacts
- **Prediction Field**: Likelihood to Convert (%)
- **Training Data**: Use Contacts where Deal was won/lost
- **Minimum Data Required**: 200+ closed deals

### Step 3: Combine Scores

Create a composite score:

**Formula**:
```
Total_Priority_Score = (Rule_Based_Score * 0.7) + (Zia_Prediction * 0.3 * 200)
```

This gives 70% weight to your explicit rules and 30% to AI predictions.

### Step 4: Continuous Learning

- Zia improves over time as more data is added
- Quarterly: Review Zia vs Rule-Based accuracy
- Adjust weighting based on which predicts better

---

## ROI Measurement

Track these metrics to measure scoring effectiveness:

| Metric | How to Calculate |
|--------|------------------|
| Conversion Rate by Score Range | (Deals Won / Prospects) by score bucket |
| Sales Cycle Length by Score | Avg days from first touch to close, by score |
| ROI per Score Range | (Revenue - Cost) / Cost, by score bucket |
| Sales Rep Time Allocation | % of time spent on 110+ scores vs below |
| False Positive Rate | % of 110+ scores that didn't convert |
| False Negative Rate | % of conversions that had scores <110 |

**Goal**: Prospects scoring 110+ should convert at 2-3x the rate of lower-scoring prospects.

---

## Implementation Checklist

- [ ] Create all custom fields in Accounts module
- [ ] Create all custom fields in Contacts module
- [ ] Configure Account Fit Score rule (0-100 points)
- [ ] Configure Persona Influence Score rule (0-50 points)
- [ ] Configure Engagement Score rule with time decay
- [ ] Create Total_Outreach_Priority_Score formula field
- [ ] Update all existing records with new scores
- [ ] Create "High Priority Prospects" custom view (score > 110)
- [ ] Build scoring dashboard with key metrics
- [ ] Create workflow automation for high-score alerts
- [ ] Test scoring with 5-10 sample prospects
- [ ] Document expected score ranges for different ICPs
- [ ] Train team on using scores for prioritization
- [ ] Set up weekly score distribution review
- [ ] Configure integration with GoHighLevel via Zapier/Zoho Flow
- [ ] Establish monthly scoring optimization process

---

## Resources & References

### Official Zoho Documentation
- [Zoho CRM Scoring Rules Overview](https://help.zoho.com/portal/en/kb/crm/automate-business-processes/scoring-rules/articles/scoring-rules)
- [Configuring Multiple Scoring Rules](https://help.zoho.com/portal/en/kb/crm/automate-business-processes/scoring-rules/articles/multiple-scoring-rule)
- [Zoho CRM Lead Scores Tips](https://www.zoho.com/crm/resources/tips/lead-scores.html)
- [Scoring Rules API Documentation](https://www.zoho.com/crm/developer/docs/api/v8/create-scoring-rules.html)
- [Zia Predictive Scoring](https://help.zoho.com/portal/en/kb/crm/automate-business-processes/scoring-rules/articles/scoring-rules-zia-scores)

### Implementation Guides
- [7 Lead Scoring Rules in Zoho CRM](https://www.aorborc.com/7-lead-scoring-rules-in-zoho-crm/) - AorBorC Technologies
- [Zoho CRM Lead Scoring Setup & Strategy Guide](https://zenatta.com/zoho-crm-lead-scoring-setup-usage/) - Zenatta
- [Scoring Rules in Zoho CRM - A Primer](https://www.marksgroup.net/blog/scoring-rules-in-zoho-crm/) - The Marks Group
- [Multiple Scoring Rules & Approval Process](https://sixtyonesteps.com/multiple-scoring-rules.html) - Sixty One Steps

### AI-Powered Scoring
- [Lead Scoring with Zia AI and Zoho CRM Insights](https://navigatecrm.com/2025/08/lead-scoring-with-zia-ai-zoho-crm/) - Navigate CRM
- [Zia Artificial Intelligence Overview](https://www.zoho.com/crm/zia/)
- [How Lead Scoring Can Be Done Smarter Using AI](https://www.zoho.com/crm/crm-express/lead-scoring-can-be-done-smarter-using-ai.html)

### Comparison & Best Practices
- [Lead Scoring in CRM: HubSpot, Zoho and Salesforce](https://liminal.pt/martech-magazine/en/lead-scoring-in-crm-how-it-works-in-hubspot-zoho-and-salesforce/) - Liminal

---

## Next Steps

1. **Review this document** with your team to align on scoring criteria
2. **Validate field mappings** - Ensure the custom fields match your data from Sales Navigator/Apollo
3. **Pilot with one Hero Bet** - Start with Generation Forecasting to test the system
4. **Iterate based on feedback** - Refine weights and criteria after first 20-30 prospects scored
5. **Scale to all five Hero Bets** - Once validated, apply to all ICPs

For questions or support with implementation, refer to Zoho CRM's official documentation or consult with a Zoho Certified Partner.

---

**Document Version**: 1.0
**Last Updated**: 2026-01-27
**Related Document**: Outreach.md (B2B Outreach System Requirements)
