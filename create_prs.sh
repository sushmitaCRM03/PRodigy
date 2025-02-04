#!/bin/bash

# Configuration
ORG_NAME="Workforce-Cloud-Tech"  # Change to your org name
HEAD_BRANCH="dev"  # Change to source branch
BASE_BRANCH="main" # Change to target branch
PR_TITLE="Regular Deployment 5th February, 2025"
PR_BODY="This PR is created by a script"

# List of repositories (Modify as needed)
REPOSITORIES=("recruitcrm-frontend-vue3" "recruitcrm-modern" "job-boards" "Albatross" "comm" ) # Add your repositories

# Store PR links
PR_LINKS=()

for REPO in "${REPOSITORIES[@]}"; do
    echo "Processing repository: $REPO"

    # Check if the repository exists on GitHub
    if gh repo view "$ORG_NAME/$REPO" &>/dev/null; then
        echo "✅ Repository $REPO found. Checking PR..."

        # Check if a PR already exists from HEAD to BASE branch
        EXISTING_PR=$(gh pr list --repo "$ORG_NAME/$REPO" --base "$BASE_BRANCH" --head "$HEAD_BRANCH" --state open -L 1)

        # Debugging: Print the output of the PR list to inspect
        echo "PR list output: $EXISTING_PR"

        # If a PR exists, get the link of the existing PR
        if [ -n "$EXISTING_PR" ]; then
            # Extract PR number from the list output
            PR_NUMBER=$(echo "$EXISTING_PR" | awk '{print $1}')
            # Get the full PR URL using the PR number
            PR_LINK="https://github.com/$ORG_NAME/$REPO/pull/$PR_NUMBER"
            PR_LINKS+=("$REPO - $PR_LINK")
            echo "❌ PR already exists for $REPO. Link: $PR_LINK"
        else
            # If no PR exists, create a new PR
            PR_LINK=$(gh pr create --repo "$ORG_NAME/$REPO" \
                                   --base "$BASE_BRANCH" \
                                   --head "$HEAD_BRANCH" \
                                   --title "$PR_TITLE" \
                                   --body "$PR_BODY" | grep -o 'https://github.com/[^ ]*')

            # Add PR link to the list
            PR_LINKS+=("$REPO - $PR_LINK")
            echo "✅ PR created for $REPO: $PR_LINK"
        fi
    else
        echo "❌ Repository $REPO does not exist! Skipping..."
    fi
done

# Print all PR links with repository names
echo -e "\n:pr-merged-1: $PR_TITLE"
for PR in "${PR_LINKS[@]}"; do
    echo "$PR"
done

echo "🎉 All PRs processed successfully!"
