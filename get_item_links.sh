#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Grabs the links from each web page that's specified in the links.txt file

# Initialize the variables
output="output/part_links.txt"
input="output/links.txt"

# Check to see if the output file exists. If it doesn't, create it. Otherwise, clear the content from it.
if [ ! -f $output ]; then
       touch $output
   else
       truncate -s 0 $output
fi

# Cycle through each link in the links.txt file.
# Grabs all of item links from the page specified from links.txt file and appends them to part_links.txt
cat $input | while read line
do
    echo $line
     wget -O- $line \
     | grep -e '<a href[^<]*<img' \
     | sed 's/^.*<a href="//g' \
     | sed 's/">.*//g' \
     >> $output
done

# Cycles through the part_links.txt file
# Since each line has a link to a particular item, the link is set to get_skus.sh to get the material numbers and skus from that page
cat $output | while read line
do
    bash ./get_skus.sh $line
done
