#!/bin/sh

vpn_running="$(pgrep "gpclient")"

if [ $# -eq 1 ]; then
    if [ -z "$vpn_running" ]; then
        `gpclient server zta.nubank.com.br --now --start-minimized`
        return
    fi
    kill "$vpn_running"
    return
fi

if [ -z "$vpn_running" ]; then
    echo "VPN off"
    return
fi

echo "VPN on"
