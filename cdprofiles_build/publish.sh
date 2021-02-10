#!/bin/bash
source config.sh

zip -r output/output.zip output

Upload latest &
Upload $VERSION &
Upload $DATE

wait 
display "Upload Complete"
