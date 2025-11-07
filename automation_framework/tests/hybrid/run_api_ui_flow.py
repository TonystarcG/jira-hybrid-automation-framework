import sys
import os

# Add project root to Python path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.append(project_root)

from hybrid_flows_clean import api_creates_ui_reads

if __name__ == "__main__":
    print("[DEBUG] Wrapper script started")
    issue_key, summary = api_creates_ui_reads()
    print(f"[DEBUG] Issue Key: {issue_key}")
    print(f"[DEBUG] Summary: {summary}")