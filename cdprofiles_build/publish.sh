#!/bin/bash
source config.sh

zip -r output/output.zip output

Upload latest &
Upload $DATE

wait 
display "Upload Complete"
