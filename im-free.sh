#!/bin/bash

echo "Welcome to the GitHub issue fetcher!"

# Prompt user for personal access token
read -p "Please enter your GitHub personal access token: " token

# Prompt user for organization name
read -p "Please enter the name of the GitHub organization to fetch issues from: " orgName

# Prompt user for label to search for
read -p "Please enter the label you would like to search for: " label

# URL encode the label for use in the API request
encodedLabel=$(echo "$label" | sed 's/ /%20/g')

# Call GitHub API to fetch issues
echo "Fetching issues..."
issues=$(curl -s -H "Authorization: Bearer $token" "https://api.github.com/orgs/$orgName/repos" | jq -r '.[].full_name' | xargs -I {} sh -c "curl -s -H 'Authorization: Bearer $token' 'https://api.github.com/repos/{}/issues?labels=$encodedLabel' | jq -r '.[] | \"{} \(.html_url) \(.title)\"'")

# Print the list of issues
echo "$issues"

