# 🔐 Linux SSH Hardening & Fail2Ban Automation Tool

## 📌 Overview

This project is an automated Linux security hardening script designed to improve SSH security, enforce authentication policies, configure firewall rules, and protect against brute-force attacks using Fail2Ban.

It supports both Debian-based and RPM-based Linux distributions.

GitHub Repository: https://github.com/ankitsinghvisen/Linux-Hardening-Automation-Script

---

## 🚀 Features

- 🔒 Secure SSH configuration (in-place updates)
- 🚫 Disable root login via SSH
- 🔑 Enable key-based authentication only
- ❌ Disable password & empty password login
- 🧱 Restrict SSH sessions and login attempts
- 📊 Enable detailed SSH logging (SOC visibility)
- 🔥 Firewall configuration (SSH only - port 22)
- 🛡️ Fail2Ban installation & SSH protection
- 📄 Automated security report generation

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
│   └── hardening.log
│
├── report/
│   └── security_report.txt
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

The script applies the following SSH settings:

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
- All other ports are blocked (optional extension)

---

## 🛡️ Fail2Ban Protection

Fail2Ban is used to protect SSH from brute-force attacks.

### Default settings:

- Max retries: 5  
- Ban time: 3600 seconds  
- Find time: 600 seconds  

It automatically monitors SSH logs and blocks malicious IPs.

---

## 📊 Security Report

After execution, a report is generated at:

```
/var/log/security_report.txt
```

It includes:

- SSH configuration status
- Firewall status
- Fail2Ban status
- Active SSH connections

---

## ⚠️ Important Warning

- Do NOT run on production servers without testing
- Ensure SSH key authentication is configured before disabling password login
- Misconfiguration may lock you out of the system

---

## 🔥 Why This Project Matters

This project demonstrates:

- Linux system administration
- SSH security hardening
- Automation scripting
- SOC / Cybersecurity fundamentals
- DevSecOps mindset

---

## 🚀 Future Improvements

- Email/Telegram alerts for Fail2Ban bans
- SIEM integration (ELK / Wazuh)
- Auto rollback on SSH misconfiguration
- HTML dashboard reporting
- Ansible playbook conversion

---

## 👨‍💻 Author

Linux & Network Engineer | Cybersecurity Enthusiast  
Focused on Linux infrastructure, automation, and security engineering.

---

## ⭐ Support

If you like this project, consider giving it a ⭐ on GitHub:

https://github.com/ankitsinghvisen/Linux-Hardening-Automation-Script
```
