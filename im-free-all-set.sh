#!/bin/bash

# Set color variables for styling
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Welcome message with style
echo -e "${GREEN}Welcome to the GitHub issue fetcher!${NC}"

# Prompt user for personal access token
read -p "Please enter your GitHub personal access token: " useToken

# Set organization name to PhazeRoOman
orgName="PhazeRoOman"

# Set label to search for to "open-work"
label="open-work"

# URL encode the label for use in the API request
encodedLabel=$(echo "$label" | sed 's/ /%20/g')

# Call GitHub API to fetch issues
echo -e "${YELLOW}Fetching issues...${NC}"
issues=$(curl -s -H "Authorization: Bearer $useToken" "https://api.github.com/orgs/$orgName/repos" | jq -r '.[].full_name' | xargs -I {} sh -c "curl -s -H 'Authorization: Bearer $useToken' 'https://api.github.com/repos/{}/issues?labels=$encodedLabel' | jq -r '.[] | \"{} \(.html_url) \(.title)\"'")

# Output issues with style
echo -e "${GREEN}Here are the issues:${NC}"
echo "$issues" | awk '{print "• " $0}'

