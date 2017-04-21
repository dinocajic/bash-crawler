#!/bin/bash

# Runs the Crawler

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# The program will grab all of the item links first.
# After it has all of the links for each item on the website,
# it traverses the links and extracts the material numbers and skus.
# Next, it splits those skus into a number (x) of files. X can be specified
# in split_skus.sh. Just change the linesperfile variable from 50 to whatever
# Once the mats_and_skus_per_page_clean.txt file is split into smaller files
# located in output/skus/sku_1.txt, ..., output/skus/sku_n.txt,
# loop_through_sku_files.sh is called. This script generates a create_query.sh
# process for each output/skus/sku_n.txt file. create_query.sh calls the
# get_pricing.sh script to get the pricing and company names from the website page.
# Since there are multiple processes running, each process's get_pricing.sh
# stores the output into the output/lowest_prices/sku_n.txt file that is the
# same name as the one found in output/skus/ folder. Once all of the processes
# are finished, all of the newly generated files that are located in the
# output/lowest_prices/ folder are merged into the finished.txt file found
# in the output/ folder. Next, check_if_lowest_price.sh cycles traverses the
# finished.txt file and checks to see if --my company-- is listed on each line.
# If it's not listed, it means that some other company has a lower price and it
# appends that partnumber, company name and price to a file named web_YY_DD_MM.txt
# and is located in the output/exports folder.

# START
# get_item_links.sh
# - get_skus.sh
# split_skus.sh
# loop_through_sku_files.sh
# - create_query.sh
#   - get_pricing.sh
# check_if_lowest_price.sh
# END

# Clears the text files thata are used in later steps
file[0]="output/finished.txt"
file[1]="output/mats_and_skus_per_page.txt"
file[2]="output/mats_and_skus_per_page_clean.txt"
file[3]="output/company_costs_for_sku.txt"
file[4]="output/part_links.txt"

for i in "${file[@]}"
do
     if [ ! -f $i ]; then
         touch $i
     else
         truncate -s 0 $i
     fi
done

# Remove all of the text files in the skus and lowest_prices folders
rm -f output/skus/*
rm -f output/lowest_prices/*
rm -f output/temp/*

# Run all of the scripts in order to crawl the site and extract lowest prices
bash ./get_item_links.sh
bash ./split_skus.sh
bash ./loop_through_sku_files.sh
bash ./check_if_lowest_price.sh
