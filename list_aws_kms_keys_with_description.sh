#!/bin/bash

# The script reads from a list of AWS KMS customer managed key IDs and extracts their description.
# The extracted information is then added to a csv file with 2 columns for better visibility.

# Input file containing AWS KMS key IDs (one key ID per line)
input_file="key_list.txt"

# Output CSV file
output_csv="kms_key_descriptions.csv"

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and configure your credentials."
    exit 1
fi

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found."
    exit 1
fi

# Create or truncate the output CSV file
echo "KeyID,Description" > "$output_csv"

# Read each key ID from the input file and retrieve its description
while IFS= read -r key_id; do
    # Trim leading and trailing whitespace from the key ID
    TRIMMED_KEY_ID=$(echo "$key_id" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    # Use AWS CLI to describe the key and extract the description
    description=$(aws kms describe-key --key-id "$TRIMMED_KEY_ID" --query 'KeyMetadata.Description' --output json)

    # Remove double quotes from the description
    key_id=$(echo "$key_id" | tr -d '"')
    description=$(echo "$description" | tr -d '"')

    # Append the key ID and description to the CSV file
    echo "$key_id,$description" >> "$output_csv"

    echo "Processed Key ID: $key_id"
done < "$input_file"

echo "Script completed. Results are stored in '$output_csv'."
