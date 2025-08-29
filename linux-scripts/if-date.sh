#!/bin/bash

today=$(date +'%d-%m')

if [ "$today" = "31-12" ]; then
    echo "NewYear"
else
    echo "end"
fi
