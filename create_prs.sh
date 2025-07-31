#!/bin/bash

# Configuration
ORG_NAME="Workforce-Cloud-Tech"
HEAD_BRANCH="security-assessment-2025"  # Change source branch
BASE_BRANCH="dev" # Change target branch
PR_TITLE="BNP-1450: Security Assessment 2025" #change pr name
PR_BODY="This PR is created by a script"
IS_UPDATE_PR_TITLE=false
IS_CHANGE_BASE_BRANCH=true   # <== New flag to change base
IS_CLOSE_EXISTING_PRS=false   # <== New flag to close PRs
NEW_BASE_BRANCH="dev"        # <== Target base branch if changing

# List of repositories
# REPOSITORIES=( "RecruitCRM-API" "recruitcrm-frontend-vue3" "External-Pages-Next" "mail-service-kit" "recruitcrm-modern" 
# "codepipeline-validator" "auditlog-package-java" "recruitcrm-candidate-microservice" "Albatross" "testtherest_framework" "RecruitCRM-Zapier"
# "studio-frontend" "recruitcrm-ui-kit-v2" "single-store" "ostrich" "Terry" "recruitcrm-auditlog-consumer" "action-log-java" "notifications-worker" 
# "comm" "neptune" "recruitcrm-report" "NylasService" "logging-java" "entity-models-java" "aurora-package-java" "recruitcrm-webapp-utility"
# "asper" "liquibase-rcrm-poc" "katia" "rcrm-auth-service" "job-boards" "RecruitCRM-Mobile-App" "executive-search-report" "recruitcrm-candidate-microservice"
# "vms-jobs-service" "vms-notification-service" "vms-hiring-pipeline-service" "vms-user-management-service" "vms-agencies-service" "vms-common-package" "vms-auth" 
# "vms-custom-logger-js-package" "vms-candidate-service" "vms-common-js-package" "vms-custom-logger-laravel")

REPOSITORIES=("recruitcrm-modern" "Albatross" "ostrich" "recruitcrm-webapp-utility" "NylasService" "executive-search-report" "recruitcrm-candidate-microservice" "recruitcrm-frontend-vue3" "RecruitCRM-Zapier" "comm")

PR_LINKS=()

for REPO in "${REPOSITORIES[@]}"; do
    echo "Processing repository: $REPO"

    # Check if the repository exists on GitHub
    if gh repo view "$ORG_NAME/$REPO" &>/dev/null; then
        echo "Repository $REPO found. Checking PR..."

        EXISTING_PR=$(gh pr list --repo "$ORG_NAME/$REPO" --head "$HEAD_BRANCH" --state open -L 1)

        if [ -n "$EXISTING_PR" ]; then
            PR_NUMBER=$(echo "$EXISTING_PR" | awk '{print $1}')
            PR_LINK="https://github.com/$ORG_NAME/$REPO/pull/$PR_NUMBER"
            PR_LINKS+=("$REPO - $PR_LINK")

            # Update title if flag is true
            if [ "$IS_UPDATE_PR_TITLE" = true ]; then
                gh pr edit --repo "$ORG_NAME/$REPO" --title "$PR_TITLE" --body "$PR_BODY" "$PR_NUMBER"
                echo "PR already exists for $REPO. Link: $PR_LINK. PR Title updated."
            else
                echo "PR already exists for $REPO. Link: $PR_LINK"
            fi
        else
            # Create PR if it doesn't exist
            PR_LINK=$(gh pr create --repo "$ORG_NAME/$REPO" \
                                   --base "$BASE_BRANCH" \
                                   --head "$HEAD_BRANCH" \
                                   --title "$PR_TITLE" \
                                   --body "$PR_BODY" | grep -o 'https://github.com/[^ ]*')

            PR_LINKS+=("$REPO - $PR_LINK")
            echo "PR created for $REPO: $PR_LINK"
        fi

        ## ------------------ ADDITIONAL ACTIONS ------------------

        if [ "$IS_CHANGE_BASE_BRANCH" = true ]; then
            if [ -n "$PR_NUMBER" ]; then
                echo "🔁 Changing base of PR #$PR_NUMBER in $REPO to $NEW_BASE_BRANCH"
                gh pr edit "$PR_NUMBER" --repo "$ORG_NAME/$REPO" --base "$NEW_BASE_BRANCH"
            fi
        fi

        if [ "$IS_CLOSE_EXISTING_PRS" = true ]; then
            if [ -n "$PR_NUMBER" ]; then
                echo "🛑 Closing PR #$PR_NUMBER in $REPO"
                gh pr close "$PR_NUMBER" --repo "$ORG_NAME/$REPO" --delete-branch=false
            fi
        fi

    else
        echo "Repository $REPO does not exist! Skipping..."
    fi
done

echo "You can copy below PR links and paste in slack channel"
echo "-----------------------------------------------"
echo -e "\n:pr-merged-1: $PR_TITLE"
for PR in "${PR_LINKS[@]}"; do
    echo "$PR"
done
echo "-----------------------------------------------"
echo "All PRs processed successfully!"
