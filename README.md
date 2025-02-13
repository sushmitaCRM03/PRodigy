### आवश्यकता❌ आलस्य✅ ही आविष्कार की जननी है!
=

---

# **PRodigy**

**PRodigy** is your ultimate automation tool to create Pull Requests (PRs) effortlessly. Born out of a need to save time (and a healthy dose of laziness), this script simplifies the tedious task of creating PRs in bulk. Why work hard when you can work smart?

---


## **Prerequisites**
Before you start, make sure you have the following:

1. **GitHub CLI Installed**: The tool relies on GitHub CLI to interact with repositories.  
2. **Authenticated GitHub Account**: Ensure proper authentication with your GitHub account.

---

## **Steps to Get Started**

### 1. Install GitHub CLI
If you don’t already have GitHub CLI installed, you can install it using Homebrew:
```bash
brew install gh
```

---

### 2. Authenticate GitHub CLI
Once installed, authenticate the CLI with your GitHub account:
```bash
gh auth login
```

---

### 3. Download and Prepare the Script
Download the `create_prs.sh` script and give it executable permissions:
```bash
chmod +x create_prs.sh
```

---

### 4. Run the Script
You’re ready to automate PR creation! Run the script using:
```bash
./create_prs.sh
```

- Specify the **base branch**, **head branch**, and the **PR title**.
- Provide the list of repositories for which PRs need to be created.

The script will take care of the rest, ensuring PRs are created quickly and efficiently.

---

## **How to Specify Repositories**
Update the script with the list of repositories for which you need PRs. Example:
```bash
REPOS=(
  "repo1"
  "repo2"
  "repo3"
)
```

---

## **Why Use PRodigy?**
- **Efficiency**: Handles bulk PR creation in minutes.
- **Flexibility**: Easily configurable for different branches and titles.
- **Simplicity**: Requires minimal setup and effort.

Embrace your laziness—let **PRodigy** do the hard work for you! 🚀

