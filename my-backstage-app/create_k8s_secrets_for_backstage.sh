#!/bin/bash

# Define the input file with secret variables and the output file
INPUT_FILE="secrets.sh"  # Replace with the path to your file with secrets
OUTPUT_FILE="my-backstage-secrets.yaml"
GOOGLE_CREDS_FILE="google-creds.json"  # Path to your Google credentials file

# Start writing the Secret manifest
echo "apiVersion: v1" > $OUTPUT_FILE
echo "kind: Secret" >> $OUTPUT_FILE
echo "metadata:" >> $OUTPUT_FILE
echo "  name: my-backstage-secrets" >> $OUTPUT_FILE
echo "type: Opaque" >> $OUTPUT_FILE
echo "data:" >> $OUTPUT_FILE

# Read each line from the input file
while IFS='=' read -r key value
do
  # Trim leading 'export ' from the key if present
  key=${key#export }

  # Skip GOOGLE_APPLICATION_CREDENTIALS line
  if [[ $key == "GOOGLE_APPLICATION_CREDENTIALS" ]]; then
    continue
  fi

  # Stop processing if the line contains 'yarn dev'
  if [[ $key == *"yarn dev"* ]]; then
    break
  fi

  # Process only non-empty lines and non-comment lines
  if [[ -n $key && $key != \#* ]]; then
    # Base64 encode the value and remove any newlines
    encoded_value=$(echo -n "$value" | base64 | tr -d '\n')

    # Append to the output file
    echo "  $key: $encoded_value" >> $OUTPUT_FILE
  fi
done < "$INPUT_FILE"

echo "Secrets have been written to $OUTPUT_FILE"
