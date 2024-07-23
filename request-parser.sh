#!/bin/bash

# Check if the script received an argument
if [ $# -eq 0 ]; then
    echo "No argument supplied. Please provide the path to extracted.xml."
    exit 1
fi

# Assign the first argument to a variable
input_file=$1

# Check if the provided file exists
if [ ! -e "$input_file" ]; then
    echo "The file $input_file does not exist."
    exit 1
fi

# Extract base64 strings from the XML file and save to allRequestsInBase64.txt
cat "$input_file" | grep "<request base64=" | awk -F'[' '{print $3}' | awk -F']]' '{print $1}' | tee allRequestsInBase64.txt >/dev/null

# Extract base64 strings for responses and save to allResponsesInBase64.txt
cat "$input_file" | grep "<response base64=" | awk -F'[' '{print $3}' | awk -F']]' '{print $1}' | tee allResponsesInBase64.txt >/dev/null

# Check if directories exist, if not create them
if [ -e ./requests-from-extractedxml/ ]; then 
    echo "requests-from-extractedxml directory exists."
else
    mkdir requests-from-extractedxml 
fi

if [ -e ./responses-from-extractedxml/ ]; then 
    echo "responses-from-extractedxml directory exists."
else
    mkdir responses-from-extractedxml 
fi


# Initialize counter
counter=1

# Decode base64 strings for requests and save to files
for i in `cat allRequestsInBase64.txt`
do
    echo $i | base64 -d | tee ./requests-from-extractedxml/request_$counter.txt
    echo ""
    echo ""
    let counter++
done

# Reset counter for responses
counter=1

# Decode base64 strings for responses and save to files
for i in `cat allResponsesInBase64.txt`
do
    echo $i | base64 -d | tee ./responses-from-extractedxml/response_$counter.txt
    echo ""
    echo ""
    let counter++
done

# Remove the temporary files
rm allRequestsInBase64.txt
rm allResponsesInBase64.txt
