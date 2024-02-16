#!/bin/bash

# Base URL for the repositories
BASE_URL="https://github.com/samgabrail/gke-sam-"

# Loop from 1 to 19 to unregister each repository
for i in {1..19}
do
  REPO_URL="${BASE_URL}${i}.git"
  
  echo "Unregistering repository: $REPO_URL from Argo CD"
  
  # Unregister the repository
  # Ensure you're already logged in to Argo CD or use a method for authentication here.
  argocd repo rm "$REPO_URL" --grpc-web
  
  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
    echo "Repository $REPO_URL successfully unregistered from Argo CD."
  else
    echo "Failed to unregister repository $REPO_URL from Argo CD."
  fi
done
