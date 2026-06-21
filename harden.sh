#!/bin/bash

LOG_FILE="/var/log/hardening.log"
REPORT_FILE="/var/log/security_report.txt"
SSH_CONFIG="/etc/ssh/sshd_config"

mkdir -p /var/log

echo "=== Linux Hardening Started ===" | tee -a $LOG_FILE


# =========================
# SSH HARDENING (SAFE EDIT)
# =========================

backup
cp $SSH_CONFIG ${SSH_CONFIG}.bak


set_ssh_param () {
    PARAM=$1
    VALUE=$2

    if grep -q "^#*${PARAM}" $SSH_CONFIG; then
        sed -i "s/^#*${PARAM}.*/${PARAM} ${VALUE}/" $SSH_CONFIG
    else
        echo "${PARAM} ${VALUE}" >> $SSH_CONFIG
    fi
}


set_ssh_param SyslogFacility AUTH
set_ssh_param LogLevel VERBOSE
set_ssh_param PermitRootLogin no
set_ssh_param StrictModes yes
set_ssh_param MaxAuthTries 6
set_ssh_param MaxSessions 5
set_ssh_param PubkeyAuthentication yes
set_ssh_param PasswordAuthentication no
set_ssh_param PermitEmptyPasswords no


systemctl restart sshd
echo "[+] SSH Hardening Applied" | tee -a $LOG_FILE


# =========================
# FIREWALL (SSH ONLY)
# =========================

if command -v ufw >/dev/null 2>&1; then
    ufw allow 22/tcp
    ufw --force enable
    echo "[+] UFW configured" | tee -a $LOG_FILE

elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --permanent --add-port=22/tcp
    firewall-cmd --reload
    echo "[+] Firewalld configured" | tee -a $LOG_FILE
fi


# =========================
# FAIL2BAN INSTALLATION
# =========================

echo "[+] Installing Fail2Ban..." | tee -a $LOG_FILE

if command -v apt >/dev/null 2>&1; then
    apt update -y
    apt install fail2ban -y

elif command -v dnf >/dev/null 2>&1; then
    dnf install fail2ban -y

elif command -v yum >/dev/null 2>&1; then
    yum install epel-release -y
    yum install fail2ban -y
fi


# =========================
# FAIL2BAN CONFIG (SSH)
# =========================

cat > /etc/fail2ban/jail.local <<EOF

[sshd]
enabled = true
port = 22
maxretry = 5
findtime = 600
bantime = 3600

EOF


systemctl enable fail2ban
systemctl restart fail2ban

echo "[+] Fail2Ban Enabled for SSH" | tee -a $LOG_FILE


# =========================
# SECURITY REPORT
# =========================

{
echo "==============================="
echo " SECURITY HARDENING REPORT"
echo " Date: $(date)"
echo "==============================="

echo ""
echo "[ SSH CONFIG ]"
grep -E "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|MaxAuthTries|MaxSessions|LogLevel|SyslogFacility" /etc/ssh/sshd_config

echo ""
echo "[ FIREWALL STATUS ]"
if command -v ufw >/dev/null 2>&1; then
    ufw status
elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --list-all
fi

echo ""
echo "[ FAIL2BAN STATUS ]"
fail2ban-client status sshd 2>/dev/null

echo "==============================="
} > $REPORT_FILE


echo "[+] Hardening Completed Successfully" | tee -a $LOG_FILE
echo "Report: $REPORT_FILE" | tee -a $LOG_FILE
