#!/bin/bash

get_input() {
    local input_name="$1"
    local input_value="${!input_name}"
    echo "$input_value"
}

# Retrieve inputs from GitHub workflow
app_name=$(get_input "app_name")
environments=$(get_input "environments")
regions=$(get_input "regions")
subscription_ids=$(get_input "subscription_ids")

# Construct the new app entry
new_app_entry="  $app_name = {
    environments = [\"${environments//,/\", \"\"}\"]
    regions     = [\"${regions//,/\", \"\"}\"]
    subscription_id = {
$(echo "$subscription_ids" | sed 's/\(.*\)/\1 = "\1"/')
    }
}"

echo $new_app_entry

tf_file_url="https://raw.githubusercontent.com/CloudiFyi-Solutions/terraform-playground/main/locals.tf"

# Use curl to download the Terraform file
curl -o locals.tf "$tf_file_url"
# Search for the line number where the lob block starts

# lob_start_line=$(grep -n 'lob = {' "$tf_file" | cut -d ":" -f 1)

# Search for the line number where the lob block ends
# lob_end_line=$(grep -n '}' "$tf_file" | grep -A1 "^$lob_start_line" | tail -n1 | cut -d ":" -f 1)

# Add the new app entry inside the lob block
# sed -i "${lob_end_line}i$new_app_entry" "$tf_file"
