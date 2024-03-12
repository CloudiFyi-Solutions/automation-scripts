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

lob_end_line=$(awk '/lob = {/{flag=1;next} /}/ && flag {print NR; flag=0}' "locals.tf")

echo $lob_end_line