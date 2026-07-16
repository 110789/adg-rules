#!/usr/bin/env bash

set -e

OUT="adg.txt"

URLS=(
"https://adrules.top/dns.txt"
"https://gcore.jsdelivr.net/gh/217heidai/adblockfilters@main/rules/adblockdns.txt"
)

TMP=$(mktemp)

echo "Downloading..."

for url in "${URLS[@]}"; do
    echo "$url"
    curl -L --retry 5 --connect-timeout 20 "$url" >> "$TMP"
    echo >> "$TMP"
done

TOTAL=$(grep -v '^$' "$TMP" | wc -l)

echo "Cleaning..."

sed 's/\r$//' "$TMP" \
| tr '[:upper:]' '[:lower:]' \
| grep -v '^!' \
| grep -v '^#' \
| grep -v '^[[:space:]]*$' \
| awk '{$1=$1};1' \
| sort -u \
> "$OUT"

FINAL=$(wc -l < "$OUT")

echo "=========="
echo "Original : $TOTAL"
echo "Final    : $FINAL"
echo "Removed  : $((TOTAL-FINAL))"

rm "$TMP"
