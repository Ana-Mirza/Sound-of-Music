#!/bin/bash

# Argument validation
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <id>"
    exit 1
fi

sudo sed -i "/rehearse_tune_$1.sh/d" /var/spool/cron/crontabs/$USER
rm rehearsals/rehearse_tune_$1.sh
