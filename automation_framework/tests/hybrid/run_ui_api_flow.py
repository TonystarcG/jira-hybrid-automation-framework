import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from automation_framework.tests.hybrid.hybrid_flows_clean import ui_creates_api_reads

print("[DEBUG] Wrapper script started")
issue_key, summary = ui_creates_api_reads()
print(f"[DEBUG] Issue Key: {issue_key}")
print(f"[DEBUG] Summary: {summary}")