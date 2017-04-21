#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Gets called from get_skus.sh
# Creates the queries and sends the queries to get_pricing.sh to get the pricing for each sku

# Initialize the variables
# input=output/mats_and_skus_per_page_clean.txt
input=$1

query=""

cat $input | while read line
do
    query=$(echo $line | sed 's/mat=//' | sed 's/sku=//' | sed 's/ : /:/' | awk -F: '{print "sku="$1"&mat="$2}')
    page=$(echo $line | awk -F: '{print $3":"$4}')
    bash ./get_pricing.sh $query $page $input
done
