#!/bin/bash
set -e

echo "Starting phirepass agent addon..."

if [ -f /data/options.json ]; then
    eval "$(jq -r 'to_entries | .[] | "export \(.key)=\(.value | @json)"' /data/options.json)"
fi

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
fi

# Configure SSH for password login
# Reference: https://github.com/hassio-addons/addon-ssh/blob/v22.0.3/ssh/rootfs/etc/ssh/sshd_config
echo "Configuring SSH for root password access..."

sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
sed -i 's/^UsePAM.*/UsePAM no/' /etc/ssh/sshd_config

# Set root password to 'root'
echo 'root:root' | chpasswd

# Start SSH server in background
echo "Starting SSH server on ${SSH_HOST}:${SSH_PORT}..."
/usr/sbin/sshd -D &

echo "Running phirepass agent..."

if [ -n "${PAT_TOKEN}" ]; then
    echo "${PAT_TOKEN}" | /app/agent login --from-stdin --server-host "${SERVER_HOST}" --server-port "${SERVER_PORT}"
else
    echo "PAT_TOKEN is empty; please provide a token for agent to login."
fi

exec /app/agent start --settings-from-file /app/settings.json
