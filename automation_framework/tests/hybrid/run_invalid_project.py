
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from automation_framework.tests.hybrid.hybrid_flows_clean import create_issue_invalid_project

if __name__ == "__main__":
    print("[DEBUG] Negative Test: Invalid Project Key")
    status_code, response_text = create_issue_invalid_project()
    print(f"[DEBUG] Status Code: {status_code}")
    print(f"[DEBUG] Response: {response_text}")
