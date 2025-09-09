#!/usr/bin/env bash
set -euo pipefail

# Simple start wrapper for Render. Ensures Prisma migrations run and the correct
# compiled entry is executed.

cd "$(dirname "$0")"

# Run migrations if DATABASE_URL present
if [ -n "${DATABASE_URL:-}" ]; then
  echo "Running prisma migrate deploy..."
  npx prisma migrate deploy || true
fi

# Prefer dist/src/main.js (Nest default) otherwise fall back
if [ -f dist/src/main.js ]; then
  echo "Starting node dist/src/main.js"
  node dist/src/main.js
elif [ -f dist/main.js ]; then
  echo "Starting node dist/main.js"
  node dist/main.js
else
  echo "Compiled entry not found. Did you run npm run build?"
  ls -la dist || true
  exit 1
fi
