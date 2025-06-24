#!/bin/bash

# Fetch latest changes from the origin remote
git fetch origin

# Pull the latest changes from the main branch
git pull origin main

# Add all changes (including new files, modified files, etc.)
git add .

# Commit the changes with a default message
git commit -m "Update changes"

# Push the changes to the origin's main branch
git push origin main

echo "Changes pushed to origin main successfully!"

