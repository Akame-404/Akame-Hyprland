##!/bin/bash

count=$(checkupdates 2>/dev/null | wc -l)

if [ "$count" -gt 1 ]; then
    echo "{\"text\": \"$count\", \"tooltip\": \"$count available updates\"}"
elif [ "$count" -eq 1 ]; then
    echo "{\"text\": \"1\", \"tooltip\": \"1 available update\"}"
else
    echo "{\"text\": \"0\", \"tooltip\": \"no updates available\"}"
fi
