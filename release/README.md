Release artifacts for weTransfer

Structure:
- backend/: compiled backend binary and backend tarball
- frontend/: static `dist` build for the frontend

How to build (from repository root):

1. Ensure Go is installed and accessible in PATH.
2. Ensure `pnpm` (recommended) or `npm` is installed for frontend builds.
3. Run the default build:

```bash
scripts/build-release.sh
```

4. To build a Raspberry Pi compatible backend for Linux ARM64, run:

```bash
GOOS=linux GOARCH=arm64 scripts/build-release.sh
```

The script will place binaries and packaged tarballs under `release/`.
