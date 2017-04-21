#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Grabs the SKU's and Material numbers for the particular item

# Initialize the variables
output_unformatted="output/mats_and_skus_per_page.txt"
output_formatted="output/mats_and_skus_per_page_clean.txt"

page=$1

# Grab the content from the page. Once it gets the content from the page, get rid of everything that's not a material number or sku.
# The output gets stored into the unformatted_file.
wget -O- $page \
| grep -e '<input name="sku" value=".*" type="hidden">' -e '<input name="mat" value=".*" type="hidden">' \
| sed 's/<input name="//' \
| sed 's/" value="/=/' \
| sed 's/" type="hidden">//' \
> $output_unformatted

# i - Since the output of material and sku is on separate lines, make it so that they appear on the same line
i=0

# test - if test is 0, supress the newline character, otherwise, insert newline
test=0

cat $output_unformatted | while read line
do
   test=$((i % 2))

   if [ "$test" -eq "0" ]
   then
        echo -n "$line : "
   else
        echo $line" : "$page
   fi
   i=$((i + 1))
done >> $output_formatted
