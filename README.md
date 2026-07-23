<p align="center">
  <img src="https://raw.githubusercontent.com/filebrowser/filebrowser/master/branding/banner.png" width="550"/>
</p>

[![Build](https://github.com/filebrowser/filebrowser/actions/workflows/ci.yaml/badge.svg)](https://github.com/filebrowser/filebrowser/actions/workflows/ci.yaml)
[![Go Report Card](https://goreportcard.com/badge/github.com/filebrowser/filebrowser/v2)](https://goreportcard.com/report/github.com/filebrowser/filebrowser/v2)
[![Version](https://img.shields.io/github/release/filebrowser/filebrowser.svg)](https://github.com/filebrowser/filebrowser/releases/latest)

File Browser provides a file managing interface within a specified directory and it can be used to upload, delete, preview and edit your files. It is a **create-your-own-cloud**-kind of software where you can just install it on your server, direct it to a path and access your files through a nice web interface.

## Documentation

Documentation on how to install, configure, and contribute to this project is hosted at [filebrowser.org](https://filebrowser.org).

## Quick Install on Raspberry Pi 4 (64-bit OS)

To install weTransfer NAS on a 64-bit Raspberry Pi OS:

```bash
curl -fsSL https://raw.githubusercontent.com/happeningsmys-ship-it/weTransfer/latest-changes/get.sh | bash
```

Once installed, open `http://<RASPBERRY_PI_IP>:8080` in your web browser.
- **Username**: `admin`
- **Password**: `admin`

## Building & Deploying Updates

1. **Build Frontend**:
   ```bash
   cd frontend && pnpm install --frozen-lockfile && pnpm run build && cd ..
   ```

2. **Cross-Compile Go Backend**:
   ```bash
   GOOS=linux GOARCH=arm64 go build -ldflags='-s -w' -o build/linux-arm64/filebrowser .
   GOOS=linux GOARCH=arm GOARM=7 go build -ldflags='-s -w' -o build/linux-armv7/filebrowser .
   ```

3. **Package & Release via GitHub CLI**:
   ```bash
   (cd build/linux-arm64 && tar -czvf ../../linux-arm64-filebrowser.tar.gz filebrowser)
   (cd build/linux-armv7 && tar -czvf ../../linux-armv7-filebrowser.tar.gz filebrowser)

   git tag v1.0.X && git push origin v1.0.X
   gh release create v1.0.X linux-arm64-filebrowser.tar.gz linux-armv7-filebrowser.tar.gz --title "v1.0.X" --notes "Release notes"
   ```

4. **Update on Raspberry Pi**:
   ```bash
   sudo systemctl stop wetransfer
   curl -fsSL https://github.com/happeningsmys-ship-it/weTransfer/releases/download/v1.0.X/linux-arm64-filebrowser.tar.gz | sudo tar -xz -C /opt/wetransfer filebrowser
   sudo mv -f /opt/wetransfer/filebrowser /opt/wetransfer/wetransfer
   sudo systemctl start wetransfer
   ```

## Project Status

This project is a finished product which fulfills its goal: be a single binary web File Browser which can be run by anyone anywhere. That means that File Browser is currently on **maintenance-only** mode.

## Contributing

Contributions are always welcome. To start contributing to this project, read our [guidelines](CONTRIBUTING.md) first.

## License

[Apache License 2.0](LICENSE) © File Browser Contributors

