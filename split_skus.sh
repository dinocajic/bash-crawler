#!/bin/bash

# Author: Dino Cajic
# Email: dinocajic@gmail.com
# Year: 2017

# Splits the SKU's into multiple pages
# Gets the number of lines in the $input file
# Divides the total number of lines by the number of lines you want to have per file
# For example, 526 total lines / 50 lines per file = 11 total text files
# Puts the lines from $input file into the generated $output files

input="output/mats_and_skus_per_page_clean.txt"
output="output/skus/sku_"

# Number of lines per file. Will dictate how many files are created in the loop later.
linesperfile=20

# Get number of lines
# Divide the number of lines by $linesperfile (i.e. 50)
# Once you divide the number of lines, store the lines into the files

# Read the number of lines located in mats_and_skus_per_page_clean.txt
numoflines=$(wc -l < "$input")

# We're going to let each process run $linesperfile (i.e. 50) lines of text in the next step, so we divide by $linesperfile (i.e. 50)
# Since numoffiles is an integer, we need to add 1 to accomodate for any additional lines
# i.e. 51 lines would require 2 files
numoffiles=$((numoflines / $linesperfile + 1))

# Initialize the current line of the $input file
currentline=1

# Initialize the file count
i=1

# Loop until $i is greater than the number of files that we're trying to create (i.e. 11)
while [ $i -le $numoffiles ]; do
    # Create the name of the file
    filename=${output}${i}".txt"

    # Initialize $j to 1
    j=1

    # Loop through the file and place the lines from the input file into the output file
    # Loop until $j is greater than $linesperfile (i.e. 50 lines per file)
    while [ $j -le $linesperfile  ]; do
        # Grab the current line of the $input file.
        # This line will be stored in the newly created output/skus/$filename file
        fileline=$(sed "${currentline}q;d" $input)

        # Place the line into the file
        echo $fileline >> $filename

        # Increment the current line of the $input file by 1
        let currentline=$currentline+1

        # Increment $j by 1 so that only a certain amount of lines can be placed into the newly created $filename
        let j=$j+1
    done

    # Increment $i so that the file names can be created (i.e. sku_$1.txt)
    let i=$i+1
done
