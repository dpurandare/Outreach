# Outreach System Project

> 📌 **New to this project?** Start with [DEVELOPER_BOOTSTRAP.md](DEVELOPER_BOOTSTRAP.md) for complete onboarding and current status, then check [tasks.md](tasks.md) for active work items.

## Overview
This repository contains the design, research, and implementation documentation for **two major projects** requested by Vinod Himatsinghani:

1. **B2B Outreach System** - Professional enterprise-grade system for JBS hero bets
2. **SLM for Field CoPilot** - ⚠️ Awaiting detailed specifications

---

## PROJECT 1: B2B Outreach System

### Purpose
Build a professional, enterprise-grade B2B outreach system using existing subscriptions (Zoho CRM, Sales Navigator, Apollo.io, GoHighLevel, LLMs) to support 5 JBS hero bets with human-sounding, high-trust messaging and measurable ROI.

### Five JBS Hero Bets
1. **Generation Forecasting** (Wind/Solar/CCGT)
2. **Sales Quote Automation**
3. **Fieldforce CoPilot**
4. **Energy Data Hub**
5. **DataOps**

---

## System Architecture Components

### Core Technology Stack
- **Zoho CRM** - System of record (accounts, contacts, pipeline, scoring)
- **Sales Navigator + Apollo.io** - Prospect discovery + enrichment
- **GoHighLevel (GHL)** - Multi-channel outreach orchestration (email + LinkedIn)
- **LLMs** (ChatGPT Pro, Claude Pro, Gemini Pro) - Research + personalization engine
- **Canva / Gamma / Napkin.ai** - Credibility assets (create assets, presentations, diagrams, etc)
- **Veed.io / HeyGen** - Optional high-touch video follow-ups (video generation)

### Key Principles
✅ AI never sends directly - Humans approve, edit, and trigger  
✅ Precision over volume - Target high-fit accounts  
✅ Multi-layer personalization (Industry + Company + Persona + JBS)  
✅ Continuous optimization with measurable ROI  

---

## Tasks & Progress

### ✅ Completed

#### Research & Documentation
- [x] System architecture design
- [x] ICP definition for 5 hero bets
- [x] Scoring mechanism design (Account Fit + Persona Influence + Engagement)
- [x] Messaging framework (4-layer personalization)
- [x] 14-day outreach cadence design
- [x] LinkedIn Sales Navigator API research ([LinkedInSalesNav.md](research/LinkedInSalesNav.md))
- [x] Apollo.io API research and capabilities ([apollo.md](research/apollo.md))
- [x] Prospect discovery & enrichment workflow ([ProspectDiscoveryEnrichment.md](research/ProspectDiscoveryEnrichment.md))
- [x] Complete system workflow diagrams ([WorkflowDiagram.md](research/WorkflowDiagram.md))

#### Infrastructure
- [x] Git repository initialized
- [x] GitHub remote repository created (private)

### 🔲 Pending Implementation

#### Phase 1: Foundation Setup
- [ ] Zoho CRM configuration
  - [ ] Custom fields for scoring (Account Fit, Persona Influence, Engagement)
  - [ ] Hero Bet tagging system
  - [ ] Dashboard setup for tracking
- [ ] Sales Navigator integration with Zoho CRM
- [ ] Apollo.io integration with Zoho CRM
- [ ] GoHighLevel (GHL) setup and integration

#### Phase 2: ICP & Scoring
- [ ] Define detailed filters for each of 5 hero bets in Sales Navigator
- [ ] Build scoring automation in Zoho CRM
  - [ ] Account Fit scoring logic (0-100)
  - [ ] Persona Influence scoring logic (0-50)
  - [ ] Engagement scoring tracker
- [ ] Set up priority threshold triggers (110+)

#### Phase 3: AI Research & Personalization
- [ ] Create prompt templates for each LLM
  - [ ] Claude Pro: Long-form research
  - [ ] Perplexity Pro: Trigger discovery
  - [ ] ChatGPT Pro: Message drafts
  - [ ] Gemini Pro: Tone variation
- [ ] Build human review workflow
- [ ] Create style guide and guardrails for messaging

#### Phase 4: Outreach Execution
- [ ] Configure 14-day cadence sequences in GoHighLevel
- [ ] Create 5 parallel outreach tracks (one per hero bet)
- [ ] Set up email templates (Day 1, 7, 10, 14)
- [ ] Define LinkedIn engagement workflow (Day 3, 5)

#### Phase 5: Credibility Assets
- [ ] Create Canva templates (one-page solution briefs per hero bet)
- [ ] Create Gamma templates (5-slide micro-decks per industry)
- [ ] Set up Veed.io/HeyGen for video follow-ups (optional)

#### Phase 6: Tracking & Optimization
- [ ] Build Zoho CRM dashboards
  - [ ] Outreach score distribution
  - [ ] Hero bet conversion rates
  - [ ] Persona response heatmap
  - [ ] Time-to-first-meeting
- [ ] Set up weekly optimization workflow
- [ ] Configure automated reporting

#### Phase 7: Compliance & Quality
- [ ] Consider implementing AI detector/humanizer (Originality.ai or GPTZero Enterprise)
- [ ] Set up compliance checks for messaging
- [ ] Create feedback loop for message quality

---

## PROJECT 2: SLM for Field CoPilot

### Status
⚠️ **AWAITING DETAILED SPECIFICATIONS FROM VINOD**

### Known Information
- Related to "Field CoPilot" (one of the 5 JBS hero bets)
- SLM likely refers to "Small Language Model" or specialized language model implementation

### Action Required
- [ ] Follow up with Vinod for detailed requirements
- [ ] Understand scope, objectives, and timeline
- [ ] Define technical specifications and integration requirements

---

## Documentation Structure

```
/
├── README.md                              # This file - Project overview and progress
├── Outreach.md                           # Complete system specification
├── email.txt                             # Email correspondence
├── FromNotes.docx                        # Original notes
└── research/
    ├── LinkedInSalesNav.md              # Sales Navigator API research
    ├── apollo.md                         # Apollo.io API research
    ├── ProspectDiscoveryEnrichment.md   # Discovery/enrichment workflow
    └── WorkflowDiagram.md               # Visual system workflow diagrams
```

---

## Next Steps

### Immediate Actions
1. **Review and approve** the B2B Outreach System architecture
2. **Confirm** which tools/subscriptions are already active
3. **Contact Vinod** for Project 2 (SLM for Field CoPilot) specifications
4. **Define priority order** between the two projects
5. **Begin Phase 1** implementation (Foundation Setup)

### Contact
For questions or updates, contact Vinod Himatsinghani.

---

*Last Updated: January 17, 2026*
