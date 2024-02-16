#!/bin/bash

# Set the GitHub username
GITHUB_USERNAME="samgabrail"

# Set the GitHub Personal Access Token as an environment variable
# For example, in your terminal you can run:
# export GITHUB_TOKEN="your_token_here"

# Check if the GITHUB_TOKEN environment variable is set
if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN is not set. Please set it before running this script."
  exit 1
fi

# Loop from 0 to 19 to construct each repo name and delete it
for i in {0..19}
do
  REPO_NAME="gke-sam-${i}"

  echo "Deleting repository: $GITHUB_USERNAME/$REPO_NAME"

  # Use the GitHub API to delete the repository
  RESPONSE=$(curl -X DELETE \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME \
  -w "%{http_code}" -o /dev/null -s)

  # Check the response code
  if [ "$RESPONSE" = "204" ]; then
    echo "Repository $GITHUB_USERNAME/$REPO_NAME successfully deleted."
  elif [ "$RESPONSE" = "404" ]; then
    echo "Repository $GITHUB_USERNAME/$REPO_NAME not found."
  else
    echo "Failed to delete repository $GITHUB_USERNAME/$REPO_NAME. HTTP status code: $RESPONSE"
  fi
done
