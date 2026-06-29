#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

GOOS_OVERRIDE=${GOOS:-$(go env GOOS)}
GOARCH_OVERRIDE=${GOARCH:-$(go env GOARCH)}
BINARY_NAME="weTransfer-${GOOS_OVERRIDE}-${GOARCH_OVERRIDE}"

rm -rf release/backend/* release/frontend/* || true
mkdir -p release/backend release/frontend

echo "Building backend for ${GOOS_OVERRIDE}/${GOARCH_OVERRIDE}..."
# Build backend binary (main package at repo root)
CGO_ENABLED=${CGO_ENABLED:-0} GOOS=${GOOS_OVERRIDE} GOARCH=${GOARCH_OVERRIDE} go build -o release/backend/${BINARY_NAME} .

echo "Building frontend..."
if command -v pnpm >/dev/null 2>&1; then
  (cd frontend && pnpm install --frozen-lockfile)
  (cd frontend && pnpm run build)
elif command -v npm >/dev/null 2>&1; then
  echo "pnpm not found, falling back to npm (may behave differently)"
  (cd frontend && npm ci)
  (cd frontend && npm run build)
else
  echo "No pnpm or npm found; please install pnpm@>=10 or npm to build the frontend." >&2
  exit 1
fi

echo "Copying frontend build to release/frontend/..."
rm -rf release/frontend/* || true
mkdir -p release/frontend
cp -R frontend/dist/. release/frontend/

echo "Creating tar archives..."
tar -C release/backend -czf release/backend-${GOOS_OVERRIDE}-${GOARCH_OVERRIDE}.tar.gz .
tar -C release -czf release/frontend-dist.tar.gz frontend

echo "Release build complete. Artifacts in release/"
echo "Backend binary: release/backend/${BINARY_NAME}"
echo "Frontend files: release/frontend/"
