#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "google-auth>=2.0.0",
#     "requests>=2.28.0",
# ]
# ///

"""
Fetch analytics metrics for ricc.rocks and goliardia via Google Analytics 4 Data API.
Usage:
    UV_INDEX_URL="https://pypi.org/simple" uv run bin/get_analytics.py
"""

import os
import sys
import json
import requests
import google.auth
from google.auth.transport.requests import Request

PROPERTIES = {
    "ricc.rocks": "557555665",
    "goliardia": "224302555",
}

def get_access_token():
    # 1. Check if token passed in environment
    if os.environ.get("GA_ACCESS_TOKEN"):
        return os.environ["GA_ACCESS_TOKEN"]

    # 2. Try ADC with analytics.readonly scope
    try:
        creds, _ = google.auth.default(scopes=["https://www.googleapis.com/auth/analytics.readonly"])
        creds.refresh(Request())
        return creds.token
    except Exception as e:
        print(f"❌ Error obtaining Google Analytics credentials: {e}")
        print("\n💡 To authorize your local machine, run:")
        print('   gcloud auth application-default login --scopes="https://www.googleapis.com/auth/analytics.readonly,https://www.googleapis.com/auth/cloud-platform"')
        sys.exit(1)

def query_realtime(token, prop_name, prop_id):
    url = f"https://analyticsdata.googleapis.com/v1beta/properties/{prop_id}:runRealtimeReport"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    payload = {
        "metrics": [{"name": "activeUsers"}],
        "dimensions": [{"name": "unifiedScreenName"}]
    }
    resp = requests.post(url, headers=headers, json=payload)
    if resp.status_code != 200:
        print(f"⚠️  Realtime API error for {prop_name} ({prop_id}): HTTP {resp.status_code} - {resp.text}")
        return

    data = resp.json()
    rows = data.get("rows", [])
    total_users = sum(int(row["metricValues"][0]["value"]) for row in rows) if rows else 0
    print(f"\n⚡ [{prop_name}] Realtime Users (last 30 min): {total_users}")
    for row in rows[:5]:
        page = row["dimensionValues"][0]["value"]
        users = row["metricValues"][0]["value"]
        print(f"   • {page}: {users} active")

def query_historical(token, prop_name, prop_id, days=7):
    url = f"https://analyticsdata.googleapis.com/v1beta/properties/{prop_id}:runReport"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    payload = {
        "dateRanges": [{"startDate": f"{days}daysAgo", "endDate": "today"}],
        "metrics": [
            {"name": "activeUsers"},
            {"name": "screenPageViews"},
            {"name": "sessions"}
        ],
        "dimensions": [{"name": "pageTitle"}]
    }
    resp = requests.post(url, headers=headers, json=payload)
    if resp.status_code != 200:
        print(f"⚠️  Standard Report API error for {prop_name} ({prop_id}): HTTP {resp.status_code} - {resp.text}")
        return

    data = resp.json()
    rows = data.get("rows", [])
    print(f"\n📊 [{prop_name}] Last {days} Days Overview:")
    if not rows:
        print("   (No recorded traffic yet for this period)")
        return

    for row in rows[:5]:
        title = row["dimensionValues"][0]["value"]
        users = row["metricValues"][0]["value"]
        views = row["metricValues"][1]["value"]
        sessions = row["metricValues"][2]["value"]
        print(f"   • {title[:40]:<40} | Views: {views:>4} | Users: {users:>3} | Sessions: {sessions:>3}")

def main():
    print("🚀 Fetching Google Analytics 4 Stats...")
    token = get_access_token()
    for name, prop_id in PROPERTIES.items():
        print(f"\n{'='*50}")
        print(f"🔍 Checking: {name} (Property ID: {prop_id})")
        print(f"{'='*50}")
        query_realtime(token, name, prop_id)
        query_historical(token, name, prop_id, days=7)

if __name__ == "__main__":
    main()
