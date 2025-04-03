#!/bin/bash

# This script helps completely remove files from git history
# WARNING: This rewrites git history and should be used with caution
# Make sure all collaborators are aware before running this script

# Check if git is initialized
if [ ! -d .git ]; then
  echo "Error: This directory is not a git repository."
  exit 1
fi

echo "=== Git History Cleanup Script ==="
echo "WARNING: This script will rewrite git history!"
echo "Only use this if you need to completely remove sensitive files or large binary files."
echo "Make sure all collaborators are aware before proceeding."
echo ""
echo "This operation is IRREVERSIBLE and will require a force push."
echo ""

# Ask for confirmation
echo "Are you absolutely sure you want to proceed? (yes/no)"
read -r response

if [[ "$response" != "yes" ]]; then
  echo "Operation cancelled. No changes were made."
  exit 0
fi

# List common patterns to remove
echo ""
echo "Common patterns to remove from git history:"
echo "1. All .DS_Store files"
echo "2. All build/ directories"
echo "3. All .dart_tool/ directories"
echo "4. All pubspec.lock files"
echo "5. All .packages files"
echo "6. Custom pattern"
echo ""

echo "Enter the number of the pattern you want to remove (or 'q' to quit):"
read -r choice

case $choice in
  1)
    pattern="**/.DS_Store"
    ;;
  2)
    pattern="**/build/"
    ;;
  3)
    pattern="**/.dart_tool/"
    ;;
  4)
    pattern="**/pubspec.lock"
    ;;
  5)
    pattern="**/.packages"
    ;;
  6)
    echo "Enter your custom pattern:"
    read -r pattern
    ;;
  q|Q)
    echo "Operation cancelled. No changes were made."
    exit 0
    ;;
  *)
    echo "Invalid choice. Operation cancelled."
    exit 1
    ;;
esac

echo ""
echo "You are about to remove '$pattern' from the entire git history."
echo "This will rewrite all commits in your repository."
echo "Are you sure you want to continue? (yes/no)"
read -r confirm

if [[ "$confirm" != "yes" ]]; then
  echo "Operation cancelled. No changes were made."
  exit 0
fi

# Use git filter-repo to remove the files
# Check if git-filter-repo is installed
if ! command -v git-filter-repo &> /dev/null; then
  echo "Error: git-filter-repo is not installed."
  echo "Please install it with: pip install git-filter-repo"
  exit 1
fi

echo ""
echo "Removing '$pattern' from git history..."
git filter-repo --path-glob "$pattern" --invert-paths

echo ""
echo "Files matching '$pattern' have been removed from git history."
echo ""
echo "IMPORTANT: You will need to force push these changes with:"
echo "  git push --force"
echo ""
echo "Make sure all collaborators are aware of this change!"
echo "They will need to re-clone the repository or use:"
echo "  git fetch origin"
echo "  git reset --hard origin/main"
echo ""
echo "=== Git History Cleanup Complete ==="
