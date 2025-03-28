#!/bin/bash

# Configuration
ORG_NAME="Workforce-Cloud-Tech"
# HEAD_BRANCH="cse-bug-release"  # Change source branch
HEAD_BRANCH="dev"  # Change source branch
BASE_BRANCH="main" # Change target branch
PR_TITLE="Regular Deployment 28th March, 2025" #change pr namae
PR_BODY="This PR is created by a script"
IS_UPDATE_PR_TITLE=false


# List of repositories
# REPOSITORIES=( "RecruitCRM-API" "recruitcrm-frontend-vue3" "External-Pages-Next" "mail-service-kit" "recruitcrm-modern" 
# "codepipeline-validator" "auditlog-package-java" "recruitcrm-candidate-microservice" "Albatross" "testtherest_framework" "RecruitCRM-Zapier"
# "studio-frontend" "recruitcrm-ui-kit-v2" "single-store" "ostrich" "Terry" "recruitcrm-auditlog-consumer" "action-log-java" "notifications-worker" 
# "comm" "neptune" "recruitcrm-report" "NylasService" "logging-java" "entity-models-java" "aurora-package-java" "recruitcrm-webapp-utility"
# "asper" "liquibase-rcrm-poc" "katia" "rcrm-auth-service" "job-boards" "RecruitCRM-Mobile-App" "executive-search-report" "recruitcrm-candidate-microservice")


# List of repositories (Modify as needed)
REPOSITORIES=("recruitcrm-modern" "Albatross" "ostrich" "recruitcrm-webapp-utility" "NylasService" "executive-search-report" "recruitcrm-candidate-microservice" "recruitcrm-frontend-vue3" "RecruitCRM-Zapier" "comm")

PR_LINKS=()

for REPO in "${REPOSITORIES[@]}"; do
    echo "Processing repository: $REPO"

    # Check if the repository exists on GitHub
    if gh repo view "$ORG_NAME/$REPO" &>/dev/null; then
        echo "Repository $REPO found. Checking PR..."

        EXISTING_PR=$(gh pr list --repo "$ORG_NAME/$REPO" --base "$BASE_BRANCH" --head "$HEAD_BRANCH" --state open -L 1)

        if [ -n "$EXISTING_PR" ]; then
            PR_NUMBER=$(echo "$EXISTING_PR" | awk '{print $1}')
            PR_LINK="https://github.com/$ORG_NAME/$REPO/pull/$PR_NUMBER"
            PR_LINKS+=("$REPO - $PR_LINK")
            # if PR already exists then update the PR Title if IS_UPDATE_PR_TITLE is true
            if [ "$IS_UPDATE_PR_TITLE" = true ]; then
                gh pr edit --repo "$ORG_NAME/$REPO" --title "$PR_TITLE" --body "$PR_BODY" $PR_NUMBER
                echo "PR already exists for $REPO. Link: $PR_LINK. PR Title updated."
            fi

            echo "PR already exists for $REPO. Link: $PR_LINK"
        else
            PR_LINK=$(gh pr create --repo "$ORG_NAME/$REPO" \
                                   --base "$BASE_BRANCH" \
                                   --head "$HEAD_BRANCH" \
                                   --title "$PR_TITLE" \
                                   --body "$PR_BODY" | grep -o 'https://github.com/[^ ]*')

            PR_LINKS+=("$REPO - $PR_LINK")
            echo "PR created for $REPO: $PR_LINK"
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
