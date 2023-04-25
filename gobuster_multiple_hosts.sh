#!/bin/bash

wordlist="./host_list.txt"
gobuster_dir=""
dir_wordlist="./big.txt"

threads=2
delay=100ms


while IFS= read -r ip; do
  echo "Running Gobuster against $ip"

  for scheme in "https://" "http://"; do
    insecure=false
    while true; do
      if [ "$insecure" = true ]; then
        echo "Running with -k (insecure) flag for $scheme$ip"
        "$gobuster_dir"gobuster dir -u "$scheme$ip" -w "$dir_wordlist" -t "$threads" --delay "$delay" -k -o "gobuster_$ip.log"
      else
        "$gobuster_dir"gobuster dir -u "$scheme$ip" -w "$dir_wordlist" -t "$threads" --delay "$delay" -o "gobuster_$ip.log"
      fi

      # If exit status is 0 (success) or not equal to 1 (certificate error), break the loop
      if [ $? -ne 1 ] || [ "$insecure" = true ]; then
        break
      fi

      insecure=true
    done
  done

done < "$wordlist"

