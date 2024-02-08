#!/bin/bash

CMD="$(headsetcontrol -b 2> /dev/null)"
SUCCESS_TOKEN="Success!"

if [[ $CMD == *"Success"* ]]; then
    BTRY_LVL="$(headsetcontrol -b | sed -n "2 p" | cut -c10-17)"
    echo "HS Battery: ${BTRY_LVL}"
 else
    echo ""
fi
