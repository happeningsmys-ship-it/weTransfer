#!/bin/bash
set -e

BINARY_URL="https://github.com/happeningsmys-ship-it/weTransfer/releases/download/v1.0.0/linux-arm64-filebrowser.tar.gz"

echo "========================================"
echo "   weTransfer NAS - Installing..."
echo "========================================"

# Create folders
sudo mkdir -p /opt/wetransfer
sudo mkdir -p /mnt/storage
sudo chmod 777 /mnt/storage

# Download & extract 64-bit binary
echo "Downloading 64-bit arm64 binary..."
curl -fsSL "$BINARY_URL" | sudo tar -xz -C /opt/wetransfer filebrowser
sudo mv -f /opt/wetransfer/filebrowser /opt/wetransfer/wetransfer
sudo chmod +x /opt/wetransfer/wetransfer

# Create systemd service
echo "Setting up systemd service..."
sudo tee /etc/systemd/system/wetransfer.service > /dev/null << SERVICE
[Unit]
Description=weTransfer NAS
After=network.target

[Service]
ExecStart=/opt/wetransfer/wetransfer -r /mnt/storage -a 0.0.0.0 -p 8080 -d /opt/wetransfer/wetransfer.db --username admin --password admin
Restart=always
User=root

[Install]
WantedBy=multi-user.target
SERVICE

# Ensure admin password is set to admin if database already exists
if [ -f /opt/wetransfer/wetransfer.db ]; then
  sudo /opt/wetransfer/wetransfer users update admin --password admin -d /opt/wetransfer/wetransfer.db 2>/dev/null || true
fi

sudo systemctl daemon-reload
sudo systemctl enable wetransfer
sudo systemctl restart wetransfer

IP=$(hostname -I | awk '{print $1}')
echo ""
echo "========================================"
echo "   INSTALL COMPLETE!"
echo "========================================"
echo ""
echo "   Open: http://$IP:8080"
echo "   Login: admin / admin"
echo ""
echo "========================================"