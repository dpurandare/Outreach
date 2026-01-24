#!/usr/bin/env python3
"""
Apollo.ai Contact Enrichment Script

This script reads test_contacts.csv, enriches each contact using Apollo.io API,
and outputs the enriched information in markdown format to enriched_info.md
"""

import csv
import json
import os
import time
from pathlib import Path

import requests
from dotenv import load_dotenv

# Load environment variables
env_path = Path(__file__).parent.parent / 'config' / '.env'
load_dotenv(env_path)

APOLLO_API_KEY = os.getenv('APOLLO_API_KEY')
if not APOLLO_API_KEY:
    raise ValueError("APOLLO_API_KEY not found in .env file")

API_ENDPOINT = "https://api.apollo.io/v1/people/enrich"

def enrich_contact(first_name, last_name, email):
    """Enrich a contact using Apollo.io API"""
    payload = {
        "api_key": APOLLO_API_KEY,
        "first_name": first_name,
        "last_name": last_name,
        "email": email
    }

    headers = {
        "Content-Type": "application/json",
        "X-Api-Key": APOLLO_API_KEY
    }

    try:
        response = requests.post(API_ENDPOINT, json=payload, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error enriching {first_name} {last_name}: {e}")
        return None

def format_person_markdown(person_data, original_data):
    """Format enriched person data as markdown"""
    person = person_data.get('person', {})

    # Basic info
    first_name = person.get('first_name', original_data['First Name'])
    last_name = person.get('last_name', original_data['Last Name'])
    name = person.get('name', f"{first_name} {last_name}")
    email = person.get('email', original_data['Email'])
    linkedin_url = person.get('linkedin_url')
    title = person.get('title')
    headline = person.get('headline')

    # Organization info
    org = person.get('organization', {})
    company_name = org.get('name', original_data['Company'])
    company_website = org.get('website_url')
    company_industry = org.get('industry')
    company_size = org.get('estimated_num_employees')
    company_revenue = org.get('organization_revenue_printed')
    company_location = f"{org.get('street_address') or ''}, {org.get('city') or ''}, {org.get('state') or ''}, {org.get('country') or ''}".strip(', ')

    # Technologies
    technologies = org.get('current_technologies', [])
    tech_names = [tech.get('name') for tech in technologies[:5]]  # Limit to 5

    markdown = f"## {name}\n\n"
    markdown += f"**Email:** {email}\n"
    if linkedin_url:
        markdown += f"**LinkedIn:** [{linkedin_url}]({linkedin_url})\n"
    if title:
        markdown += f"**Title:** {title}\n"
    if headline:
        markdown += f"**Headline:** {headline}\n"

    markdown += f"\n### Company Information\n\n"
    markdown += f"**Company:** {company_name}\n"
    if company_website:
        markdown += f"**Website:** [{company_website}]({company_website})\n"
    if company_industry:
        markdown += f"**Industry:** {company_industry}\n"
    if company_size:
        markdown += f"**Size:** {company_size} employees\n"
    if company_revenue:
        markdown += f"**Revenue:** {company_revenue}\n"
    if company_location.strip(', '):
        markdown += f"**Location:** {company_location.strip(', ')}\n"

    if tech_names:
        markdown += f"**Technologies:** {', '.join(tech_names)}\n"

    # Original CSV data for reference
    markdown += f"\n### Original Data\n\n"
    markdown += f"- **Job Title:** {original_data['Job Title']}\n"
    markdown += f"- **Phone:** {original_data['Phone']}\n"
    markdown += f"- **Location:** {original_data['Location']}\n"
    markdown += f"- **Industry:** {original_data['Industry']}\n"
    markdown += f"- **Company Size:** {original_data['Company Size']}\n"

    markdown += f"\n---\n\n"

    return markdown

def main():
    # Input and output paths
    csv_path = Path(__file__).parent.parent / 'data' / 'test_contacts.csv'
    output_path = Path(__file__).parent.parent / 'data' / 'enriched_info.md'

    if not csv_path.exists():
        print(f"Error: CSV file not found at {csv_path}")
        return

    enriched_data = []

    with open(csv_path, 'r', newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)

        for row in reader:
            first_name = row['First Name'].strip()
            last_name = row['Last Name'].strip()
            email = row['Email'].strip()

            if not all([first_name, last_name, email]):
                print(f"Skipping row with missing data: {row}")
                continue

            print(f"Enriching: {first_name} {last_name} ({email})")

            enriched = enrich_contact(first_name, last_name, email)

            if enriched:
                markdown = format_person_markdown(enriched, row)
                enriched_data.append(markdown)
            else:
                # Fallback: create basic markdown from original data
                markdown = f"## {first_name} {last_name}\n\n"
                markdown += f"**Email:** {email}\n"
                markdown += f"**Company:** {row['Company']}\n"
                markdown += f"**Job Title:** {row['Job Title']}\n\n"
                markdown += f"*(Enrichment failed)*\n\n---\n\n"
                enriched_data.append(markdown)

            # Rate limiting: wait 1 second between requests
            time.sleep(1)

    # Write to output file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# Enriched Contact Information\n\n")
        f.write("Generated from Apollo.io API enrichment\n\n")
        f.write("---\n\n")
        f.writelines(enriched_data)

    print(f"\nEnrichment complete! Output written to {output_path}")

if __name__ == "__main__":
    main()