#!/bin/bash

LOG_FILE="/var/log/hardening.log"
REPORT_FILE="/var/log/security_report.txt"
SSH_CONFIG="/etc/ssh/sshd_config"
F2B_JAIL="/etc/fail2ban/jail.local"
F2B_ACTION="/etc/fail2ban/action.d/custom-mail.conf"

ADMIN_EMAIL="admin@example.com"

mkdir -p /var/log

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" | tee -a "$LOG_FILE"
}

log "INFO" "=== Linux Hardening Started ==="


# =========================
# SSH BACKUP
# =========================

cp "$SSH_CONFIG" "${SSH_CONFIG}.bak"
log "INFO" "SSH config backup created"


# =========================
# SSH HARDENING
# =========================

set_ssh_param () {
    PARAM=$1
    VALUE=$2

    if grep -q "^#\?${PARAM}" "$SSH_CONFIG"; then
        sed -i "s|^#\?${PARAM}.*|${PARAM} ${VALUE}|" "$SSH_CONFIG"
    else
        echo "${PARAM} ${VALUE}" >> "$SSH_CONFIG"
    fi

    log "SECURITY" "Set SSH: ${PARAM} ${VALUE}"
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
log "INFO" "SSH restarted"


# =========================
# FIREWALL
# =========================

if command -v ufw >/dev/null 2>&1; then
    ufw allow 22/tcp
    ufw --force enable
    log "INFO" "UFW enabled"

elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --permanent --add-port=22/tcp
    firewall-cmd --reload
    log "INFO" "Firewalld enabled"
fi


# =========================
# FAIL2BAN + MAIL INSTALL
# =========================

log "INFO" "Installing Fail2Ban + Mail system..."

if command -v apt >/dev/null 2>&1; then
    apt update -y
    apt install -y fail2ban sendmail mailutils

elif command -v dnf >/dev/null 2>&1; then
    dnf install -y fail2ban sendmail mailx

elif command -v yum >/dev/null 2>&1; then
    yum install -y epel-release
    yum install -y fail2ban sendmail mailx
fi

systemctl enable sendmail >/dev/null 2>&1
systemctl start sendmail >/dev/null 2>&1


# =========================
# CUSTOM EMAIL ACTION
# =========================

cat > "$F2B_ACTION" <<EOF
[Definition]

actionban = printf "Hello Admin,

==================================================
SECURITY ALERT: SSH BRUTE FORCE DETECTED
==================================================

Host           : $(hostname)
Jail           : sshd
Attacker IP    : %(__ip)s
Time           : $(date)
Attempts       : %(failures)d

--------------------------------------------------
ACTION TAKEN
--------------------------------------------------
Status         : IP has been blocked automatically
Ban Duration   : %(bantime)d seconds

==================================================
This is an automated security alert from Fail2Ban.
Please do not reply to this email.
==================================================
" | mail -s "🚨 SECURITY ALERT: SSH BRUTE FORCE DETECTED on $(hostname)" $ADMIN_EMAIL

EOF

log "INFO" "Custom Fail2Ban email action created"


# =========================
# FAIL2BAN CONFIG
# =========================

cat > "$F2B_JAIL" <<EOF

[DEFAULT]
destemail = $ADMIN_EMAIL
sender = fail2ban@$(hostname)
mta = sendmail
action = custom-mail

[sshd]
enabled = true
port = 22
maxretry = 5
findtime = 600
bantime = 3600

EOF

systemctl enable fail2ban
systemctl restart fail2ban

log "INFO" "Fail2Ban configured"


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
} > "$REPORT_FILE"


log "INFO" "Hardening completed"
log "INFO" "Report: $REPORT_FILE"
