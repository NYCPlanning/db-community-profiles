#!/bin/bash
source config.sh

Upload staging &
Upload $DATE

wait 
display "Upload Complete"
