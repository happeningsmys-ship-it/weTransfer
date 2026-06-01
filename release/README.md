Release artifacts for weTransfer

Structure:
- backend/: compiled backend binary and backend tarball
- frontend/: static `dist` build for the frontend

How to build (from repository root):

1. Ensure Go is installed and accessible in PATH.
2. Ensure `pnpm` (recommended) or `npm` is installed for frontend builds.
3. Run:

```bash
scripts/build-release.sh
```

The script will place binaries and packaged tarballs under `release/`.
