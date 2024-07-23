#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No argument supplied. Please provide the path to extracted.xml."
    exit 1
fi

input_file=$1

if [ ! -e "$input_file" ]; then
    echo "The file $input_file does not exist."
    exit 1
fi

cat "$input_file" | grep "<request base64=" | awk -F'[' '{print $3}' | awk -F']]' '{print $1}' | tee allRequestsInBase64.txt >/dev/null

cat "$input_file" | grep "<response base64=" | awk -F'[' '{print $3}' | awk -F']]' '{print $1}' | tee allResponsesInBase64.txt >/dev/null

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

counter=1

for i in `cat allRequestsInBase64.txt`
do
    echo $i | base64 -d | tee ./requests-from-extractedxml/request_$counter.txt
    echo ""
    echo ""
    let counter++
done

counter=1

for i in `cat allResponsesInBase64.txt`
do
    echo $i | base64 -d | tee ./responses-from-extractedxml/response_$counter.txt
    echo ""
    echo ""
    let counter++
done

rm allRequestsInBase64.txt
rm allResponsesInBase64.txt
