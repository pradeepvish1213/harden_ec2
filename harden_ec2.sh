#!/bin/bash

# Update and Upgrade System
sudo apt update && sudo apt upgrade -y

# Disable Root Login
sudo passwd -l root

# Create a New User
USERNAME="myuser"
sudo adduser --gecos "" $USERNAME
sudo usermod -aG sudo $USERNAME

# Enable Automatic Security Updates
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure unattended-upgrades

# Modify SSH Configuration
SSH_CONFIG="/etc/ssh/sshd_config"
sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' $SSH_CONFIG
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' $SSH_CONFIG
echo "AllowUsers $USERNAME" | sudo tee -a $SSH_CONFIG
echo "MaxAuthTries 3" | sudo tee -a $SSH_CONFIG
echo "ClientAliveInterval 300" | sudo tee -a $SSH_CONFIG
echo "ClientAliveCountMax 2" | sudo tee -a $SSH_CONFIG

# Change SSH Port (Optional: Change 2222 to your preferred port)
SSH_PORT=2222
sudo sed -i "s/^#Port 22/Port $SSH_PORT/" $SSH_CONFIG
sudo systemctl restart ssh

# Configure Firewall (UFW)
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow $SSH_PORT/tcp
sudo ufw allow 80/tcp  # Allow HTTP
sudo ufw allow 443/tcp # Allow HTTPS
sudo ufw enable

# Install and Configure Fail2Ban
sudo apt install fail2ban -y
cat <<EOL | sudo tee /etc/fail2ban/jail.local
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = $SSH_PORT
EOL
sudo systemctl restart fail2ban

# Disable Unused Services
for SERVICE in avahi-daemon cups exim4 postfix; do
  sudo systemctl disable $SERVICE 2>/dev/null
  sudo systemctl stop $SERVICE 2>/dev/null
done

# Enable Audit Logging
sudo apt install auditd -y
sudo systemctl enable auditd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes

# Install Logwatch for Monitoring
sudo apt install logwatch -y

# Install AIDE for Intrusion Detection
sudo apt install aide -y
aideinit
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Set Kernel Security Options
echo "* hard core 0" | sudo tee -a /etc/security/limits.conf

# Enable AppArmor
sudo apt install apparmor apparmor-utils -y
sudo systemctl enable apparmor

# Disable IP Spoofing
echo "nospoof on" | sudo tee -a /etc/host.conf

# Install Malware Scanner (ClamAV)
sudo apt install clamav -y
sudo freshclam

# Install Lynis for Security Audits
sudo apt install lynis -y

# Restart services
sudo systemctl restart ssh
sudo systemctl restart fail2ban

# Completion Message
echo "Server hardening and security setup complete!"
