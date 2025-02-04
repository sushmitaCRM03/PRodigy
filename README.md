PR-Creator
This script helps automate the process of creating pull requests via GitHub CLI.

Prerequisites
Before you run the script, ensure you have the following:

GitHub CLI installed
Proper authentication with your GitHub account
Steps to Run
1. Install GitHub CLI
If you don't have GitHub CLI installed, you can install it using Homebrew:

-- brew install gh

2. Authenticate GitHub CLI
Once GitHub CLI is installed, authenticate it with your GitHub account by running:

-- gh auth login

3. Make the Script Executable
After downloading the create_prs.sh script, give it executable permissions:

-- chmod +x create_prs.sh

4. Run the Script
Now you're ready to use the script. Simply execute the following command to run it:

-- ./create_prs.sh

The script will handle the process of creating the pull requests as required.

Just change the base, head branch and the title

Along with this add Repos for which PR needs to be created
