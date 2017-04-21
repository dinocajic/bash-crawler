#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Gets the pricing per SKU.
# The query is generated in create_query.sh
# Once the query is generated, it calls this script (get_pricing.sh) and passes the query string as the parameter
# Once the query is executed, the output (price/company name), is saved into the temp folder. The file from the
# temp folder will then be read and each line appended to a file $output located in skus/lowest_prices/

output=$3
output=$(echo $output | sed 's/skus/lowest_prices/')

temp=$(echo $3 | sed 's/skus/temp/')

#query=sku=xxx&mat=xxxx
query=$1

page=$2

# Sends a request to the website and extracts the selling price for each company
wget -O- --post-data=$query $page \
| grep -e '<td valign="middle" align="center">\$.*<br></td>' -e 'name=dealer value=.*>' \
| sed 's/<input type=hidden name=dealer value=//' \
| sed 's/>//' \
| sed 's/<td valign="middle" align="center"//' \
| sed 's/<br><\/td>//' \
| sed 's/[[:space:]]\+//' > $temp

echo "SKU : $1" >> $output

# Reads the saved $temp file and formats the output as $PRICE : COMPANY NAME
# i and test - Needed to know when to insert new line character
i=0
test=0

# Read the temp file and append the information to the $output file
cat $temp | while read line
do
   test=$((i % 2))

   if [ "$test" -eq "0" ]
   then
	echo -n "$line : "
   else
        echo $line
   fi

   i=$((i + 1))
done >> $output
