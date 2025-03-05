# EC2 Ubuntu Server Hardening & Security Script

## Overview
This script automates the hardening and security setup for an AWS EC2 Ubuntu server. It enhances security by disabling root login, configuring a firewall, setting up intrusion detection, and enabling system monitoring.

## Features
- Updates and upgrades system packages.
- Disables root login for better security.
- Creates a new sudo user for administrative access.
- Configures SSH for enhanced security.
- Sets up a firewall (UFW) with essential rules.
- Installs and configures Fail2Ban to prevent brute-force attacks.
- Disables unused services to reduce attack surface.
- Enables audit logging and intrusion detection with AIDE.
- Configures automatic security updates.
- Installs ClamAV for malware scanning.
- Installs Lynis for security auditing.
- Configures AppArmor for process security.

## Usage
1. **Download the script:**
   ```bash
   wget https://github.com/pradeepvish1213/harden_ec2/harden_ec2.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x harden_ec2.sh
   ```

3. **Run the script with sudo:**
   ```bash
   sudo ./harden_ec2.sh
   ```

## Important Notes
- The script **disables direct root login**, but you can still gain root access using:
  ```bash
  sudo su -
  ```
- SSH port is changed to `2222` by default. Modify as needed before running the script.
- Ensure your security group allows the new SSH port.

## Reverting Changes
- To **re-enable root login**, unlock the root account:
  ```bash
  sudo passwd root
  ```
- Modify `/etc/ssh/sshd_config` and set `PermitRootLogin yes`.
- Restart SSH:
  ```bash
  sudo systemctl restart ssh
  ```

## License
This script is open-source and can be modified to suit your needs. Use at your own risk!

