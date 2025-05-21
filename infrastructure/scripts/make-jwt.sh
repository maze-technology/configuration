#!/usr/bin/env bash
set -euo pipefail

APP_ID=$1                 # e.g. 123456
INSTALLATION_ID=$2        # e.g. 987654321
PRIVATE_KEY=$3            # path to *.pem

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

iat=$(date +%s)
exp=$((iat + 540))        # GitHub allows max 10 min

header=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
payload=$(printf '{"iat":%d,"exp":%d,"iss":%d}' "$iat" "$exp" "$APP_ID" | b64url)
unsigned="$header.$payload"

signature=$(printf %s "$unsigned" | \
  openssl dgst -sha256 -sign "$PRIVATE_KEY" | b64url)

echo "$unsigned.$signature"
