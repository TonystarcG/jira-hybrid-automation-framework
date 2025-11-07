*** Variables ***

# Base URLs
${JIRA_URL}           https://hritwick05sas.atlassian.net
${API_URL}            https://hritwick05sas.atlassian.net/rest/api/2/issue

# Authentication
${USERNAME}           hritwick.singh05@gmail.com
${PASSWORD}           password123
${INVALID_USERNAME}   invalid_user
${INVALID_PASSWORD}   wrong_pass

# Project and Issue Details
${PROJECT_KEY}        DEMO
${ISSUE_TYPE_TASK}    Task
${ISSUE_TYPE_BUG}     Bug
${ISSUE_TYPE_STORY}   Story

# Sample Summaries
${SUMMARY_API}        API created issue
${SUMMARY_UI}         UI created issue
${SUMMARY_NEGATIVE}   Invalid issue test
${SUMMARY_CROSS}      Cross-validation issue
