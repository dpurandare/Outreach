# Developer Bootstrap Guide
**Outreach Automation System - Energy Industry Sales**

> 📌 **Start Here:** Read this document at the beginning of every session to quickly understand the project context, current status, and what needs to be done next.

**Last Updated:** January 30, 2026 (Major Update)  
**Project Owner:** Vinod Himatsinghani  
**Current Phase:** Phase 1 → Phase 2 Transition (APIs Ready, Moving to Data & Integration)

---

## 🎯 Project Mission

Build a professional, enterprise-grade B2B outreach system using existing subscriptions (Zoho CRM, Sales Navigator, Apollo.io, GoHighLevel, LLMs) to support **5 JBS hero bets** with human-sounding, high-trust messaging and measurable ROI.

### The 5 JBS Hero Bets
1. **Generation Forecasting** (Wind/Solar/CCGT)
2. **Sales Quote Automation**
3. **Fieldforce CoPilot**
4. **Energy Data Hub**
5. **DataOps**

---

## 📁 Repository Structure

```
/Users/Deepak/Public/Outreach/
│
├── README.md                    # Project overview and high-level architecture
├── Outreach.md                  # Original work request from Vinod
├── tasks.md                     # 🔥 ACTIVE TASK LIST - Update after every session!
├── DEVELOPER_BOOTSTRAP.md       # 👈 THIS FILE - Read first every session
├── LinkedInIssue.md             # LinkedIn API access issues and workarounds
├── ZOHOScoringRules.md          # Scoring logic for leads
├── oauth_url.txt                # OAuth URLs for integrations
├── scribble.txt                 # Temporary notes and ideas
│
├── config/                      # Configuration files for integrations
│
├── data/                        # Data files and test datasets
│   ├── enriched_info.md         # Sample enriched contact data from Apollo.io
│   └── test_contacts.csv        # Test data for API validation
│
├── expcode/                     # Experimental code
│   └── enrich_contacts.py       # Python script for Apollo.io enrichment
│
├── input/                       # Input files for processing
│   ├── email.txt                # Email templates
│   ├── raw-19-jan.txt           # Raw input from meetings
│   └── transcript-19-jan.txt    # Meeting transcripts
│
├── research/                    # Research documentation and API analysis
│   ├── ApolloInfo.md            # Apollo.io API capabilities and endpoints
│   ├── LinkedInSalesNav.md      # Sales Navigator integration research
│   ├── LinkedInLeadsExport.md   # LinkedIn export methods
│   ├── LSN.md                   # LinkedIn Sales Navigator notes
│   ├── ProspectDiscoveryEnrichment.md  # Workflow for discovery + enrichment
│   ├── WorkflowDiagram.md       # System workflow diagrams
│   ├── ZOHO-API.md              # Zoho CRM API documentation
│   ├── ZohoLinkedIn.md          # Zoho-LinkedIn integration notes
│   └── zoho-api-try.md          # Zoho API testing notes
│
└── scripts/                     # API testing and automation scripts
│   ├── apollo_test.sh           # Apollo.io API test script
│   ├── linkedinapitest.sh       # LinkedIn API test script
│   └── zohoapitest.sh           # Zoho CRM API test script
│
└── tmp/                         # Temporary files and work-in-progress
    ├── scribble.txt             # Temporary notes and scratch work
    └── tasks.md                 # Temporary task files (not critical)
```

---

## 📚 Key Documents to Read

### Start Here (Priority Order)
1. **[DEVELOPER_BOOTSTRAP.md](DEVELOPER_BOOTSTRAP.md)** (this file) - Context and current status
2. **[tasks.md](tasks.md)** - Current tasks, priorities, and what's next
3. **[README.md](README.md)** - System architecture and completed work
4. **[Outreach.md](Outreach.md)** - Original requirements and ICP definitions

### When Working on Specific Areas

#### System Architecture & Workflow
- **[research/WorkflowDiagram.md](research/WorkflowDiagram.md)** - Complete system workflow diagrams
- **[research/ProspectDiscoveryEnrichment.md](research/ProspectDiscoveryEnrichment.md)** - How Sales Nav + Apollo work together
- **[research/ZOHOScoringRules.md](research/ZOHOScoringRules.md)** - Lead scoring logic

#### API Integrations
- **[research/ApolloInfo.md](research/ApolloInfo.md)** - Apollo.io API endpoints and capabilities
- **[research/ZOHO-API.md](research/ZOHO-API.md)** - Zoho CRM API documentation
- **[research/LinkedInSalesNav.md](research/LinkedInSalesNav.md)** - Sales Navigator integration
- **[research/LinkedInIssue.md](research/LinkedInIssue.md)** - Known LinkedIn API access issues

#### Testing & Experimentation
- **[scripts/](scripts/)** - Shell scripts for API testing
- **[expcode/enrich_contacts.py](expcode/enrich_contacts.py)** - Python enrichment script
- **[data/test_contacts.csv](data/test_contacts.csv)** - Test dataset
- **[data/enriched_info.md](data/enriched_info.md)** - Sample enriched output

---

## 🎯 Current Status

### ✅ Completed Work
- [x] System architecture design
- [x] ICP definition for all 5 hero bets
- [x] Scoring mechanism design (Account Fit + Persona Influence + Engagement)
- [x] Messaging framework (4-layer personalization)
- [x] 14-day outreach cadence design
- [x] LinkedIn Sales Navigator API research
- [x] Apollo.io API research and capabilities
- [x] Prospect discovery & enrichment workflow documentation
- [x] Complete system workflow diagrams
- [x] Git repository initialized with GitHub remote (private)
- [x] Python enrichment script created for Apollo.io testing
- [x] Apollo.io API test script executed successfully (apollo_test.sh)
- [x] Apollo.io API access confirmed and validated
- [x] Zoho CRM API access confirmed and tested successfully
- [x] LinkedIn Sales Navigator access secured
- [x] All core integrations (Apollo, Zoho, Sales Nav) operational

### 🔄 In Progress
- [ ] Building enrichment workflow with test CSV data
- [ ] Analyzing Apollo.io API response data structure
- [ ] Setting up Zoho CRM custom fields for scoring
- [ ] Zoho CRM trial setup and API exploration
- [ ] Documenting Vinod's qualification scoring logic

### ⚠️ Blockers
- **Qualification Logic:** Vinod's extensive scoring logic needs to be documented (call scheduled)
- **Field Mapping:** Need to document field mapping between Apollo.io → Sales Navigator → Zoho CRM

### ✅ Recently Resolved
- ✅ Apollo.io API access - Working and validated
- ✅ Zoho CRM API access - Working and validated
- ✅ LinkedIn Sales Navigator access - Secured and available

---

## 🚀 Last Session Activities (January 30, 2026)

### What Was Done
1. ✅ Created comprehensive [DEVELOPER_BOOTSTRAP.md](DEVELOPER_BOOTSTRAP.md) for developer onboarding
2. ✅ Established update protocol for tasks.md and documentation maintenance
3. ✅ Created [UPDATE_PROTOCOL.md](UPDATE_PROTOCOL.md) quick reference guide
4. ✅ Successfully executed Apollo.io API test (apollo_test.sh) - multiple times
5. ✅ Validated Apollo.io API access and enrichment functionality
6. ✅ Confirmed Zoho CRM API access and successful test
7. ✅ Secured LinkedIn Sales Navigator access
8. ✅ All three core integration APIs now operational

### Key Decisions Made
- **Documentation:** Bootstrap document serves as project memory for session continuity
- **Update Protocol:** tasks.md updated every session, DEVELOPER_BOOTSTRAP.md for major changes only
- **Integration Status:** All core APIs (Apollo, Zoho, Sales Nav) are working - ready for integration work
- **Temporary Files:** Created tmp/ folder for work-in-progress and temporary files

### Next Session Priorities
1. **Field Mapping:** Document Apollo.io → Sales Navigator → Zoho CRM field mappings
2. **Enrichment Workflow:** Build end-to-end enrichment pipeline with test data
3. **Zoho Configuration:** Set up custom fields for scoring system
4. **Qualification Logic:** Schedule call with Vinod to document scoring criteria

---

## 🔧 Technology Stack

### Core Systems
- **Zoho CRM** - System of record (accounts, contacts, pipeline, scoring)
- **Sales Navigator** - Prospect discovery and targeting
- **Apollo.io** - Contact enrichment and email verification
- **GoHighLevel (GHL)** - Multi-channel outreach orchestration
- **LLMs** - Research and personalization (ChatGPT Pro, Claude Pro, Gemini Pro)

### Supporting Tools
- **Canva / Gamma / Napkin.ai** - Credibility assets (presentations, diagrams)
- **Veed.io / HeyGen** - Optional video follow-ups

### Development Tools
- **Python** - Enrichment scripts and automation
- **Shell Scripts** - API testing (bash/zsh)
- **Git/GitHub** - Version control (private repository)

---

## 🎯 Key Principles

1. **AI Never Sends Directly** - Humans approve, edit, and trigger all messages
2. **Precision Over Volume** - Target high-fit accounts, not spray and pray
3. **Multi-Layer Personalization** - Industry + Company + Persona + JBS solution
4. **Continuous Optimization** - Track metrics and refine approach
5. **Data Quality First** - Cross-verify data from multiple sources

---

## 📊 System Architecture Overview

### Data Flow
```
Sales Navigator (Discovery)
    ↓
Apollo.io (Enrichment)
    ↓
Zoho CRM (System of Record + Scoring)
    ↓
LLMs (Personalization + Research)
    ↓
Human Review & Approval
    ↓
GoHighLevel (Outreach Orchestration)
    ↓
Tracking & Analytics (Back to Zoho)
```

### Scoring System
- **Account Fit Score:** 0-100 (industry, size, complexity, tech maturity)
- **Persona Influence Score:** 0-50 (decision maker, budget owner, role changes)
- **Engagement Score:** Rolling (email opens, replies, clicks, meetings)
- **Priority Threshold:** 110+ triggers immediate outreach

---

## 📋 Task Management

### Task File: [tasks.md](tasks.md)
The **tasks.md** file is the **single source of truth** for all development activities. It contains:
- Current priorities for the day
- Detailed task breakdown by phase
- Status tracking (completed, in-progress, pending)
- Blockers and key questions
- Timeline estimates

### Update Protocol
**After every work session:**
1. ✅ Mark completed tasks with timestamps
2. 🔄 Update in-progress tasks with current status
3. 📝 Add new tasks identified during work
4. ⚠️ Document any new blockers or issues
5. 🎯 Update priorities for next session

### Task Categories
- **Phase 1:** Environment Setup (1-2 hours)
- **Phase 2:** Data & Qualification Logic (2-3 hours)
- **Phase 3:** CRM Configuration (3-4 hours)
- **Phase 4:** AI Research & Personalization (2-3 hours)
- **Phase 5:** Outreach Execution (3-4 hours)
- **Phase 6:** Monitoring & Optimization (Ongoing)

---

## 🔑 Critical Information

### API Access Status
| Service | Status | Notes |
|---------|--------|-------|
| Apollo.io | ✅ Operational | API tested and validated - enrichment working |
| Zoho CRM | ✅ Operational | API access confirmed and tested successfully |
| Sales Navigator | ✅ Operational | Access secured and available |
| GoHighLevel | ✅ Available | Via existing subscription |

### Contact Information
- **Project Owner:** Vinod Himatsinghani
- **Apollo.io Contact:** Neha Sharma (for demo/API access)

### Important URLs
- GitHub Repository: Private (configured)
- OAuth URLs: See [oauth_url.txt](oauth_url.txt)

---

## ⚡ Quick Start for New Session

1. **Read this document** (DEVELOPER_BOOTSTRAP.md) - 5 minutes
2. **Review [tasks.md](tasks.md)** - Check current priorities and status - 3 minutes
3. **Check for blockers** - Any new API access or approvals needed? - 2 minutes
4. **Identify next task** - Pick highest priority from tasks.md - 1 minute
5. **Start working** - Execute, document, update tasks.md

---

## 📝 Document Update History

| Date | Update | Changed By |
|------|--------|------------|
| Jan 30, 2026 (Latest) | 🎉 Major milestone: All APIs operational (Apollo, Zoho, Sales Nav) | Development Team |
| Jan 30, 2026 (PM) | Apollo.io API test successful - Updated status | Development Team |
| Jan 30, 2026 (AM) | Initial bootstrap document created | System |
| Jan 20, 2026 | Project assessment and task list created | Development Team |
| Jan 19, 2026 | Initial research and architecture design | Development Team |

---

## 🎓 Learning Resources

### For New Developers
- Start with [README.md](README.md) for big picture
- Read [Outreach.md](Outreach.md) for business context
- Review [research/WorkflowDiagram.md](research/WorkflowDiagram.md) for technical flow
- Check [research/ProspectDiscoveryEnrichment.md](research/ProspectDiscoveryEnrichment.md) for data workflow

### For API Integration Work
- Apollo.io: [research/ApolloInfo.md](research/ApolloInfo.md)
- Zoho CRM: [research/ZOHO-API.md](research/ZOHO-API.md)
- LinkedIn: [research/LinkedInSalesNav.md](research/LinkedInSalesNav.md)
- Test scripts: [scripts/](scripts/) directory

---

## 🚨 Important Notes

1. **Always update tasks.md** after completing work or identifying new tasks
2. **Update this bootstrap document** after major milestones or status changes
3. **Document blockers immediately** in both tasks.md and this file
4. **Keep research organized** - Add new findings to appropriate research/ files
5. **Test with sample data first** - Use data/test_contacts.csv before production

---

## 💡 Tips for Success

- **Start each session fresh** - Read this doc + tasks.md to avoid context loss
- **Document as you go** - Don't rely on memory between sessions
- **Ask questions early** - Flag unknowns in tasks.md for Vinod's input
- **Test incrementally** - Validate each integration before moving forward
- **Keep data clean** - Use Zoho as single source of truth

---

**Remember:** This is a precision system, not a volume system. Quality over quantity in every step.

---

*This document should be updated after every significant work session or status change. New developers should read this first, then dive into [tasks.md](tasks.md) for specific work items.*
