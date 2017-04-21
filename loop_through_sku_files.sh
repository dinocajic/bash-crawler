#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Cycles through each of the files in the output/skus/ folder
# and calls the create_query.sh as a process
# i.e. if there are 10 files, it'll create 10 processes

# i - for process array key
i=0

for filename in output/skus/*.txt; do
    bash ./create_query.sh $filename > /dev/null 2>&1 &

    process[$i]=$!

    let i=$i+1
done

# We want to wait for each process to finish
for i in "${process[@]}"
do
     wait $i
done

# Merge all of the files into 1 file
cat output/lowest_prices/*.txt > output/finished.txt
