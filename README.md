# 🔐 Linux SSH Hardening & Fail2Ban Automation Tool

## 📌 Overview

This project is an automated Linux security hardening and monitoring script designed to improve SSH security, enforce authentication policies, configure firewall rules, and provide real-time brute-force attack alerts using Fail2Ban with email notifications.

It also generates SOC-style logs and security reports for system auditing and monitoring.

It supports both Debian-based and RPM-based Linux distributions.

GitHub Repository: https://github.com/ankitsinghvisen/Linux-Hardening-Automation-Script

---

## 🚀 Features

- 🔒 Secure SSH configuration (in-place safe updates)
- 🚫 Disable root login via SSH
- 🔑 Enforce key-based authentication only
- ❌ Disable password & empty password login
- 🧱 Restrict SSH login attempts and sessions
- 📊 SOC-style structured logging with timestamps
- 🔥 Firewall configuration (SSH only - port 22)
- 🛡️ Fail2Ban installation & SSH brute-force protection
- 📧 Email alerts for security incidents (Fail2Ban integration)
- 📄 SOC-style automated security report generation
- 📦 Automatic installation of required dependencies (sendmail, mailutils)

---

## ⚙️ Supported OS

- 🐧 Debian / Ubuntu / Kali Linux (APT)
- 🟢 RHEL / CentOS / Fedora (YUM / DNF)

---

## 📂 Project Structure

```
linux-hardening-tool/
│
├── harden.sh              # Main automation script
├── logs/
│   └── hardening.log      # SOC-style logs with timestamps
│
├── report/
│   └── security_report.txt # Security audit report
│
└── README.md
```

---

## 🛠️ Installation & Usage

### 1️⃣ Clone Repository

```bash
git clone https://github.com/ankitsinghvisen/Linux-Hardening-Automation-Script.git
cd Linux-Hardening-Automation-Script
```

### 2️⃣ Give Execution Permission

```bash
chmod +x harden.sh
```

### 3️⃣ Run Script (Root Required)

```bash
sudo ./harden.sh
```

---

## 🔐 SSH Hardening Configuration

The script applies the following secure SSH settings:

```
SyslogFacility AUTH
LogLevel VERBOSE
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
StrictModes yes
MaxAuthTries 6
MaxSessions 5
```

---

## 🔥 Firewall Configuration

- Only SSH port (22/tcp) is allowed
- Optional support for UFW and Firewalld
- All other ports are blocked by default (based on system configuration)

---

## 🛡️ Fail2Ban Protection

Fail2Ban protects SSH from brute-force attacks by monitoring authentication logs and automatically blocking malicious IPs.

### Default settings:

- Max retries: 5  
- Ban time: 3600 seconds  
- Find time: 600 seconds  

### 📧 Email Alert System (NEW)

When an attack is detected, Fail2Ban sends a structured email alert:

- Attacker IP address
- Jail name (sshd)
- Timestamp
- Number of failed attempts
- Auto-ban confirmation

Email delivery is handled using:
- Sendmail
- Mailutils / Mailx

---

## 📊 Security Report

After execution, a SOC-style security report is generated at:

```
/var/log/security_report.txt
```

### Report includes:

- SSH configuration status
- Firewall status
- Fail2Ban status
- Active SSH connections
- System security summary

---

## ⚠️ Important Warning

- Do NOT run on production servers without testing
- Ensure SSH key authentication is configured before disabling password login
- Misconfiguration may lock you out of the system
- Always keep console access (cloud/VPS recovery) enabled

---

## 🔥 Why This Project Matters

This project demonstrates real-world DevSecOps and SOC practices:

- Linux system administration
- SSH security hardening
- Security automation scripting
- Incident detection & response (Fail2Ban)
- SOC-style logging & reporting
- DevSecOps automation mindset

---

## 🚀 Future Improvements

- 📲 Telegram instant alert integration (faster than email)
- 🌍 GeoIP tracking for attacker IPs
- 📊 SIEM integration (Wazuh / ELK Stack)
- 📈 Web dashboard for security monitoring
- 🔁 Auto rollback for SSH misconfiguration
- 🧠 AI-based anomaly detection layer

---

## 👨‍💻 Author

Linux & Network Engineer | Cybersecurity Enthusiast  
Focused on Linux infrastructure, automation, and security engineering.

---

## ⭐ Support

If you like this project, consider giving it a ⭐ on GitHub:

https://github.com/ankitsinghvisen/Linux-Hardening-Automation-Script
