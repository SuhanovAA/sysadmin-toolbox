#!/bin/bash

for (( i=1; i<15; i++ ))
do
    if [[ $i -gt 5 && $i -lt 10 ]]; then
        continue
    fi
    echo "Value: $i"
done
