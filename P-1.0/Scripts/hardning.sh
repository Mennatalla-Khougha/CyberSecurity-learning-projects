#!/usr/bin/env bash

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "[-] Error: This script must be run as root (sudo)." >&2
    exit 1
fi

set -euo pipefail

# Determine who ran sudo
REAL_USER="${SUDO_USER:-khougha}"
REAL_USER_HOME=$(eval echo "~$REAL_USER")

echo "===================================================="
echo "          Linux VM Hardening Automation             "
echo "===================================================="

# 1. DYNAMIC USER PROMPT
read -p "[?] Enter the username for the target user: " TARGET_USER

if [ -z "$TARGET_USER" ]; then
    echo "[-] Error: Username cannot be blank." >&2
    exit 1
fi

# 2. USER CREATION
if id "$TARGET_USER" &>/dev/null; then
    echo "[+] User '$TARGET_USER' already exists."
else
    echo "[*] Creating user '$TARGET_USER'..."
    adduser --disabled-password --gecos "" "$TARGET_USER"
fi

# 3. GENERATE SSH KEY PAIR AS THE TARGET USER
TARGET_SSH_DIR="/home/$TARGET_USER/.ssh"
TARGET_PUB_KEY="$TARGET_SSH_DIR/id_ed25519.pub"

echo "[*] Generating ED25519 SSH key pair for '$TARGET_USER'..."
mkdir -p "$TARGET_SSH_DIR"

# Ensure the directory is owned by target user so ssh-keygen doesn't make root files
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_SSH_DIR"
chmod 700 "$TARGET_SSH_DIR"

# Run ssh-keygen as the target user to keep permissions correct
if [ ! -f "$TARGET_SSH_DIR/id_ed25519" ]; then
    sudo -u "$TARGET_USER" ssh-keygen -t ed25519 -N "" -f "$TARGET_SSH_DIR/id_ed25519"
else
    echo "[+] SSH key pair already exists for '$TARGET_USER'."
fi

# 4. APPEND TARGET USER'S PUBLIC KEY TO KHOUGHA'S AUTHORIZED_KEYS
REAL_USER_SSH_DIR="$REAL_USER_HOME/.ssh"
REAL_USER_AUTH_KEYS="$REAL_USER_SSH_DIR/authorized_keys"

echo "[*] Appending '$TARGET_USER' public key to '$REAL_USER' authorized_keys..."
mkdir -p "$REAL_USER_SSH_DIR"

# Append the public key securely
cat "$TARGET_PUB_KEY" >> "$REAL_USER_AUTH_KEYS"

# Standardize permissions for your main user
chmod 700 "$REAL_USER_SSH_DIR"
chmod 600 "$REAL_USER_AUTH_KEYS"
chown -R "$REAL_USER:$REAL_USER" "$REAL_USER_SSH_DIR"

# 5. HARDEN SSH CONFIGURATION
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "[*] Adjusting SSH Daemon policies..."

# Backup config
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak.$(date +%s)"

# Disable root login globally
if grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
elif grep -q "^#PermitRootLogin" "$SSHD_CONFIG"; then
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
else
    echo "PermitRootLogin no" >> "$SSHD_CONFIG"
fi

# Remove previous match block for this specific user if it exists to avoid duplicates
sed -i '/Match User '"$TARGET_USER"'/,+2d' "$SSHD_CONFIG"

# Append the password restriction block for the target user at the bottom
cat << EOF >> "$SSHD_CONFIG"

Match User $TARGET_USER
    PasswordAuthentication no
EOF

# Restart SSH service
if systemctl is-active --quiet ssh; then
    systemctl restart ssh
else
    systemctl restart sshd
fi

# 6. CONFIGURING UFW FIREWALL
echo "[*] Setting firewall rules..."
ufw --force reset > /dev/null
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

echo -e "\n===================================================="
echo "[+] Hardening script execution complete!"
echo "    - Target User: $TARGET_USER (Password Auth Disabled)"
echo "    - Public key added to: $REAL_USER_AUTH_KEYS"
echo "===================================================="