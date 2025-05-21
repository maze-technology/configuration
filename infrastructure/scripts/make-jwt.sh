#!/usr/bin/env bash
# Generate a GitHub-App JWT and output it as JSON
# Usage: make-jwt.sh <APP_ID> <INSTALLATION_ID> <PRIVATE_KEY_PATH>

set -euo pipefail

APP_ID="$1"
PRIVATE_KEY="$2"

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

iat=$(date +%s)
exp=$((iat + 540))          # 9 min → < GitHub’s 10 min max

header=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
payload=$(printf '{"iat":%d,"exp":%d,"iss":%d}' "$iat" "$exp" "$APP_ID" | b64url)
unsigned="$header.$payload"

signature=$(printf %s "$unsigned" | openssl dgst -sha256 -sign "$PRIVATE_KEY" | b64url)
jwt="$unsigned.$signature"

# External data sources *must* return a JSON map of strings
printf '{"jwt":"%s"}' "$jwt"
