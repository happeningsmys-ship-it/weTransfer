cat > get.sh << 'SCRIPT'
#!/bin/bash
set -e

BINARY_URL="https://raw.githubusercontent.com/happeningsmys-ship-it/weTransfer/front-back-release/release/backend/weTransfer-linux-arm64"

echo "========================================"
echo "   weTransfer NAS - Installing..."
echo "========================================"

# Create folders
sudo mkdir -p /opt/wetransfer
sudo mkdir -p /mnt/storage
sudo chmod 777 /mnt/storage

# Download binary
echo "Downloading binary..."
sudo curl -fsSL "$BINARY_URL" -o /opt/wetransfer/wetransfer
sudo chmod +x /opt/wetransfer/wetransfer

# Create systemd service
echo "Setting up service..."
sudo tee /etc/systemd/system/wetransfer.service > /dev/null << SERVICE
[Unit]
Description=weTransfer NAS
After=network.target

[Service]
ExecStart=/opt/wetransfer/wetransfer -r /mnt/storage -a 0.0.0.0 -p 8080
Restart=always
User=root

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable wetransfer
sudo systemctl start wetransfer

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
SCRIPT