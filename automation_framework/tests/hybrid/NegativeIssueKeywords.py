from automation_framework.tests.hybrid.hybrid_flows_clean import (
    create_issue_invalid_project,
    create_issue_unsupported_type,
    create_issue_malformed_payload
)

class NegativeIssueKeywords:
    def create_issue_with_invalid_project_key(self):
        return create_issue_invalid_project()

    def create_issue_with_unsupported_issue_type(self):
        return create_issue_unsupported_type()

    def create_issue_with_malformed_payload(self):
        return create_issue_malformed_payload()

    def status_should_be(self, actual_status, expected_status):
        if int(actual_status) != int(expected_status):
            raise AssertionError(f"Expected status {expected_status}, got {actual_status}")

    def response_should_contain(self, response, expected_text):
        if expected_text not in response:
            raise AssertionError(f"Expected text '{expected_text}' not found in response.")