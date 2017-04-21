#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Traverses the finished.txt file to find out which company is the cheapest.
# If --my company-- is not the cheapest, the cheapest company, price and sku is
# saved to the $export_file (i.e. web_YY_DD_MM)
input="output/finished.txt"

# Convert the $input file into an array
readarray file_to_array < $input

i=1
declare -A Price_array

for x in "${file_to_array[@]}"
do
    # If the line contains a SKU, create a sku variable
    if [[ $x == *"SKU"* ]]; then
        sku=$(echo $x | sed 's/SKU : mat=//' | sed 's/&sku=.*//')
        i=1

    # If the line doesn't contain a SKU, it means it contains the company/price information
    # Grab the company name and company price.
    else
        company_name=$(echo $x | sed 's/ : /:/' | awk -F: '{print $2}')
        company_price=$(echo $x | sed 's/ : /:/' | awk -F: '{print $1}' | sed 's/\$//' | sed 's/\..*//')

        # Check to see if the sku variable has been set as the array key
        # If it has not, it means that the loop is reading the content immediately below the line that containss the SKU information
        # Since it's the first line below the sku, it is techinically considered the cheapest of the field
        if [[ $i -eq 1 ]]; then
            Price_array[$sku]=$company_name":"$company_price
            i=0

        # If it's not the first line below the SKU, the cheapest has already been set and we have to see if the next line has cheaper pricing
        else
            current_lowest_price=$(echo ${Price_array[$sku]} | awk -F: '{print $2}' | sed 's/\$//' | sed 's/\..*$//')

            #  If it does have cheaper pricing, or if the cheapest pricing matches --my company-- pricing, update the array with the new company information
            if [[ $company_price -lt $current_lowest_price || ($company_price -eq $current_lowest_price && $company_name == "MyCompany") ]]; then
                Price_array[$sku]=$company_name":"$company_price
            fi
        fi
    fi
done

today=`date '+%Y_%m_%d'`;
export_file="output/exports/web_${today}.txt"

# Traverse the array and if --my company-- is not the company listed, add it to the $export_file
for K in "${!Price_array[@]}";
do
    if [[ "${Price_array[$K]}" != *"MyCompany"* ]]; then
        echo $K - ${Price_array[$K]} >> $export_file
    fi
done
