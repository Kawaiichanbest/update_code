#!/bin/bash

while true; do
    radius=$((RANDOM % 20 + 10))
    x=$((RANDOM % 80))
    y=$((RANDOM % 20))

    tput cup $y $x
    echo -e "\033[91m●\033[0m"

    sleep 0.1
done