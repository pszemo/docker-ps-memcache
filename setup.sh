#!/bin/bash
set -e

# Load .env
if [ ! -f .env ]; then
    echo "[setup] .env not found. Copy .env.example to .env first."
    exit 1
fi

source .env

PS_DIR="./prestashop"
PS_URL="${PS_DOWNLOAD_URL:-https://assets.prestashop3.com/dst/edition/corporate/9.0.2-2.1/prestashop_edition_classic_version_9.0.2-2.1.zip}"

# Check if PS already downloaded
if [ -f "${PS_DIR}/index.php" ]; then
    echo "[setup] PrestaShop already present in ${PS_DIR}/, skipping download."
    echo "[setup] To reinstall, remove the prestashop/ directory first."
    exit 0
fi

mkdir -p "${PS_DIR}"

echo "[setup] Downloading PrestaShop from:"
echo "        ${PS_URL}"
curl -fsSL "${PS_URL}" -o /tmp/prestashop_outer.zip

echo "[setup] Extracting..."
unzip -q /tmp/prestashop_outer.zip -d /tmp/ps_outer

# PS zip contains another zip inside
if [ -f /tmp/ps_outer/prestashop.zip ]; then
    unzip -q /tmp/ps_outer/prestashop.zip -d "${PS_DIR}"
else
    # Some versions extract directly
    cp -r /tmp/ps_outer/. "${PS_DIR}/"
fi

# Cleanup
rm -rf /tmp/prestashop_outer.zip /tmp/ps_outer

echo ""
echo "========================================"
echo " PrestaShop downloaded and extracted!"
echo " Next steps:"
echo "   1. docker compose up -d"
echo "   2. Open http://localhost:${APP_PORT:-8081}/install"
echo "   3. Install using wizard (DB host: mysql)"
echo "========================================"
