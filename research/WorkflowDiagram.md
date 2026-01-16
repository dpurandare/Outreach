# B2B Outreach System Workflow Diagram

## Overall System Architecture

```mermaid
flowchart TD
    Start[Start: Identify Target Accounts] --> SN[Sales Navigator<br/>Account-level Targeting]
    
    SN --> |Export Accounts| Apollo[Apollo.io<br/>Contact Enrichment]
    
    Apollo --> |Verified Emails<br/>Job Tenure<br/>Tech Stack| Zoho[Zoho CRM<br/>Master Record]
    
    Zoho --> Score[Scoring Engine<br/>Account Fit + Persona + Engagement]
    
    Score --> |Score < 110| LowPriority[Low Priority Pool<br/>Nurture Campaign]
    Score --> |Score ≥ 110| HighPriority[High Priority Pool]
    
    HighPriority --> Research[AI Research Layer<br/>Claude + Perplexity + ChatGPT]
    
    Research --> |Company Context<br/>Triggers<br/>Pain Points| Personalize[Message Personalization<br/>4 Layers]
    
    Personalize --> Human[Human Review & Edit<br/>⚠️ AI Never Sends Directly]
    
    Human --> GHL[GoHighLevel<br/>Multi-channel Orchestration]
    
    GHL --> Email[Email Outreach<br/>Day 1, 7, 10, 14]
    GHL --> LinkedIn[LinkedIn Engagement<br/>Day 3, 5]
    
    Email --> Track[Engagement Tracking]
    LinkedIn --> Track
    
    Track --> |High Engagement| Assets[Credibility Assets<br/>Gamma/Canva/Veed]
    Track --> |Low Engagement| Adjust[Adjust Messaging<br/>Update Score]
    
    Assets --> Meeting[Meeting Booked]
    Adjust --> Score
    
    Meeting --> Pipeline[Sales Pipeline<br/>Zoho CRM]
    
    Track --> Dashboard[Zoho Dashboards<br/>Weekly Optimization]
    
    style SN fill:#e1f5ff
    style Apollo fill:#e1f5ff
    style Zoho fill:#fff4e1
    style Research fill:#f0e1ff
    style Human fill:#ffe1e1
    style GHL fill:#e1ffe1
    style Meeting fill:#90ee90
```

## Detailed Process Flow by Stage

### Stage 1: Prospect Discovery
```mermaid
flowchart LR
    A[Sales Navigator Filters] --> B[Industry<br/>Company Size<br/>Geography<br/>Leadership Changes]
    B --> C[Export Account List]
    C --> D[Apollo.io Import]
    D --> E[Contact Enrichment<br/>Email Verification<br/>Tech Stack Discovery]
    E --> F[Push to Zoho CRM]
```

### Stage 2: Scoring & Prioritization
```mermaid
flowchart TD
    Input[New Contact in CRM] --> AF[Account Fit Score<br/>0-100]
    Input --> PI[Persona Influence Score<br/>0-50]
    
    AF --> |Industry Fit: 25<br/>Asset Scale: 20<br/>Data Complexity: 20<br/>Tech Maturity: 15<br/>Geography: 10<br/>JBS Alignment: 10| Calc
    
    PI --> |Decision Maker: +20<br/>Budget Owner: +10<br/>New Role: +10<br/>LinkedIn Active: +5<br/>Shared Connections: +5| Calc
    
    Calc[Calculate Total Score] --> Decision{Score ≥ 110?}
    
    Decision --> |Yes| High[High-Touch<br/>Personalized Outreach]
    Decision --> |No| Low[Low-Touch<br/>Nurture Campaign]
```

### Stage 3: AI Research & Personalization
```mermaid
flowchart TD
    Start[High Priority Contact] --> Layer1[Layer 1: Industry Context<br/>Grid Volatility / Renewables / Data Silos]
    
    Layer1 --> Layer2[Layer 2: Company-Specific Trigger<br/>Earnings / New Asset / Hiring Trends]
    
    Layer2 --> Layer3[Layer 3: Persona Pain<br/>Forecast Accuracy / Manual Quoting / Data Reliability]
    
    Layer3 --> Layer4[Layer 4: JBS Credibility<br/>Customer Stories / Partnerships / Outcomes]
    
    Layer4 --> Tools[AI Tools]
    
    Tools --> Claude[Claude Pro<br/>Long-form Research]
    Tools --> Perplexity[Perplexity Pro<br/>Fact-checked Triggers]
    Tools --> ChatGPT[ChatGPT Pro<br/>Message Drafts]
    Tools --> Gemini[Gemini Pro<br/>Tone Variation]
    
    Claude --> Draft[Message Draft]
    Perplexity --> Draft
    ChatGPT --> Draft
    Gemini --> Draft
    
    Draft --> Human[Human Review<br/>Edit & Approve]
```

### Stage 4: Outreach Execution (14-Day Cadence)
```mermaid
gantt
    title 14-Day Outreach Cadence
    dateFormat YYYY-MM-DD
    
    section Email
    Personalized Email          :2026-01-01, 1d
    Value Follow-up Email       :2026-01-07, 1d
    Soft Nudge Email            :2026-01-10, 1d
    Breakup Email (Polite)      :2026-01-14, 1d
    
    section LinkedIn
    Profile View                :2026-01-03, 1d
    Connection Request          :2026-01-05, 1d
```

### Stage 5: Engagement Tracking & Optimization
```mermaid
flowchart TD
    Outreach[Outreach Sent] --> Monitor[Monitor Engagement]
    
    Monitor --> Open[Email Open<br/>+5 Points]
    Monitor --> Reply[Email Reply<br/>+20 Points]
    Monitor --> View[LinkedIn View<br/>+10 Points]
    Monitor --> Click[Content Click<br/>+10 Points]
    Monitor --> Book[Meeting Booked<br/>+50 Points]
    
    Open --> Update[Update Engagement Score]
    Reply --> Update
    View --> Update
    Click --> Update
    Book --> Update
    
    Update --> Check{High Engagement?}
    
    Check --> |Yes| Assets[Send Credibility Assets<br/>Gamma Deck / Canva Brief]
    Check --> |No| Optimize[Weekly Optimization<br/>Refine Messaging]
    
    Assets --> Meeting[Schedule Meeting]
    Optimize --> Retry[Continue Cadence]
```

## Hero Bet Segmentation

```mermaid
flowchart LR
    CRM[Zoho CRM] --> HB1[Generation Forecasting<br/>IPPs, Utilities]
    CRM --> HB2[Sales Quote Automation<br/>B2B Services]
    CRM --> HB3[Fieldforce CoPilot<br/>O&M Firms]
    CRM --> HB4[Energy Data Hub<br/>GenCos, Traders]
    CRM --> HB5[DataOps<br/>Data Enterprises]
    
    HB1 --> Cadence1[Custom ICP<br/>Custom Messaging<br/>Custom Scoring]
    HB2 --> Cadence2[Custom ICP<br/>Custom Messaging<br/>Custom Scoring]
    HB3 --> Cadence3[Custom ICP<br/>Custom Messaging<br/>Custom Scoring]
    HB4 --> Cadence4[Custom ICP<br/>Custom Messaging<br/>Custom Scoring]
    HB5 --> Cadence5[Custom ICP<br/>Custom Messaging<br/>Custom Scoring]
```

## System Integration Map

```mermaid
graph TB
    subgraph Discovery
        SN[Sales Navigator]
        Apollo[Apollo.io]
    end
    
    subgraph Core["Core System of Record"]
        Zoho[Zoho CRM]
    end
    
    subgraph Intelligence["AI Intelligence Layer"]
        Claude[Claude Pro]
        Perplexity[Perplexity Pro]
        ChatGPT[ChatGPT Pro]
        Gemini[Gemini Pro]
    end
    
    subgraph Execution["Outreach Execution"]
        GHL[GoHighLevel]
    end
    
    subgraph Assets["Credibility Assets"]
        Gamma[Gamma]
        Canva[Canva]
        Veed[Veed.io]
        HeyGen[HeyGen]
    end
    
    SN --> |Accounts| Apollo
    Apollo --> |Enriched Contacts| Zoho
    Zoho --> |Contact Data| Intelligence
    Intelligence --> |Personalized Messages| GHL
    GHL --> |Email & LinkedIn| Prospects[Target Prospects]
    Zoho --> |High-Score Accounts| Assets
    Assets --> |Tailored Materials| Prospects
    Prospects --> |Engagement Data| Zoho
```

---

## Key Principles

1. **Human in the Loop**: AI generates inputs, not outputs. Humans review and approve all messages.
2. **Precision over Volume**: Target high-fit accounts with personalized messaging.
3. **Multi-layer Personalization**: Industry context + company triggers + persona pain + JBS credibility.
4. **Continuous Optimization**: Weekly analysis of what's working, kill low-performers, double down on high-performers.
5. **Hero Bet Segmentation**: Each of the 5 JBS hero bets gets its own ICP, messaging, and cadence.

---

*This workflow diagram is based on the B2B Outreach System defined in Outreach.md*
