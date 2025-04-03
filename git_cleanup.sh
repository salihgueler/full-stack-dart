#!/bin/bash

# This script helps remove files that were accidentally committed to git
# It will create a .gitignore file if it doesn't exist and add common patterns
# Then it will remove tracked files that should be ignored according to .gitignore

# Check if git is initialized
if [ ! -d .git ]; then
  echo "Error: This directory is not a git repository."
  exit 1
fi

echo "=== Git Cleanup Script ==="
echo "This script will help remove files that should be ignored from git."
echo "Make sure you have committed or stashed any important changes before proceeding."
echo ""

# Make sure all .gitignore files are in place
echo "Checking .gitignore files..."

# List of directories to check for .gitignore files
directories=("." "backend" "serverpod_backend" "frontend" "shared" "presentation")

for dir in "${directories[@]}"; do
  if [ -d "$dir" ] && [ ! -f "$dir/.gitignore" ]; then
    echo "Warning: $dir/.gitignore is missing. Please create it first."
  else
    echo "✓ $dir/.gitignore exists"
  fi
done

echo ""
echo "=== Files that should be ignored but are currently tracked ==="
git ls-files --ignored --exclude-standard

echo ""
echo "Do you want to remove these files from git tracking? (y/n)"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Removing files from git tracking (but keeping them on disk)..."
  git ls-files --ignored --exclude-standard | xargs git rm --cached
  
  echo "Committing the changes..."
  git commit -m "Remove files that should be ignored according to .gitignore"
  
  echo ""
  echo "Done! The files are now untracked but still exist on your disk."
  echo "Make sure to push these changes to update the remote repository."
else
  echo "Operation cancelled. No changes were made."
fi

# Additional cleanup for common build artifacts
echo ""
echo "Do you want to also clean up common build artifacts? (y/n)"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Cleaning up build artifacts..."
  
  # Clean Dart/Flutter build artifacts
  if [ -d "backend" ]; then
    (cd backend && dart pub get && dart run build_runner clean) || echo "Could not clean backend build artifacts"
  fi
  
  if [ -d "serverpod_backend" ]; then
    (cd serverpod_backend && dart pub get && dart run build_runner clean) || echo "Could not clean serverpod_backend build artifacts"
  fi
  
  if [ -d "frontend" ]; then
    (cd frontend && flutter clean) || echo "Could not clean frontend build artifacts"
  fi
  
  if [ -d "shared" ]; then
    (cd shared && dart pub get && dart run build_runner clean) || echo "Could not clean shared build artifacts"
  fi
  
  echo "Build artifacts cleaned up."
else
  echo "Skipping build artifact cleanup."
fi

echo ""
echo "=== Git Cleanup Complete ==="
