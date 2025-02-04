#!/bin/bash

# Configuration
ORG_NAME="Workforce-Cloud-Tech"
HEAD_BRANCH="dev"  # Change source branch
BASE_BRANCH="main" # Change target branch
PR_TITLE="Regular Deployment 5th February, 2025" #change pr namae
PR_BODY="This PR is created by a script"

# List of repositories (Modify as needed)
REPOSITORIES=("recruitcrm-frontend-vue3" "recruitcrm-modern" "job-boards" "Albatross" "comm" ) 

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

echo -e "\n:pr-merged-1: $PR_TITLE"
for PR in "${PR_LINKS[@]}"; do
    echo "$PR"
done

echo "All PRs processed successfully!"
