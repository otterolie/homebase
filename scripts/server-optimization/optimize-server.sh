#\!/bin/bash

# Server Optimization Script for Debian VPS
# Part of homebase - One-command server hardening
# Usage: sudo ./optimize-server.sh

set -e

echo "🔧 Server Optimization Script"
echo "=============================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root or with sudo"
  exit 1
fi

# Phase 1: Configure Swap
echo "📋 Phase 1: Configuring Swap..."
if [ \! -f /swapfile ]; then
  echo "  Creating 2GB swapfile..."
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  
  # Make permanent
  if \! grep -q "/swapfile" /etc/fstab; then
    echo "/swapfile none swap sw 0 0" >> /etc/fstab
  fi
  
  echo "  ✅ Swap configured"
else
  echo "  ⏭️  Swap already exists"
fi

# Phase 2: Auto-Update Configuration
echo "📋 Phase 2: Optimizing Auto-Update Configuration..."
sed -i 's|//Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";|Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";|' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Remove-New-Unused-Dependencies "true";|Unattended-Upgrade::Remove-New-Unused-Dependencies "true";|' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Remove-Unused-Dependencies "false";|Unattended-Upgrade::Remove-Unused-Dependencies "true";|' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|// Unattended-Upgrade::SyslogEnable "false";|Unattended-Upgrade::SyslogEnable "true";|' /etc/apt/apt.conf.d/50unattended-upgrades
echo "  ✅ Auto-updates optimized"

# Phase 3: System Resource Limits
echo "📋 Phase 3: Configuring System Resource Limits..."
cat > /etc/security/limits.d/99-custom.conf << 'LIMITSEOF'
# File descriptor limits (Node.js needs this)
*                soft    nofile          65536
*                hard    nofile          65536
root             soft    nofile          65536
root             hard    nofile          65536

# Process limits
*                soft    nproc           8192
*                hard    nproc           8192

# Security: disable core dumps
*                hard    core            0
LIMITSEOF
echo "  ✅ Resource limits configured"

# Phase 4: Journald Optimization
echo "📋 Phase 4: Optimizing Journald Logging..."
mkdir -p /etc/systemd/journald.conf.d/
cat > /etc/systemd/journald.conf.d/99-optimization.conf << 'JOURNALDEOF'
[Journal]
# Limit disk usage
SystemMaxUse=100M
SystemKeepFree=500M
SystemMaxFileSize=10M
MaxRetentionSec=2week

# Compress logs
Compress=yes

# Rate limiting (prevent log spam from filling disk)
RateLimitIntervalSec=30s
RateLimitBurst=10000
JOURNALDEOF
systemctl restart systemd-journald
echo "  ✅ Journald optimized"

# Phase 5: SSH Performance & Security Hardening
echo "📋 Phase 5: Hardening SSH..."
cat > /etc/ssh/sshd_config.d/99-performance.conf << 'SSHEOF'
# Prevent SSH session timeouts
ClientAliveInterval 60
ClientAliveCountMax 3
TCPKeepAlive yes

# Performance
Compression no
UseDNS no

# Security limits
LoginGraceTime 30
MaxStartups 3:50:10
SSHEOF
sshd -t && systemctl reload sshd
echo "  ✅ SSH hardened"


# Phase 6: Network Tuning (sysctl)
echo "📋 Phase 6: Applying Network Tuning..."
if ! grep -q "tcp_keepalive_time = 600" /etc/sysctl.d/99-vps-tuning.conf 2>/dev/null; then
  cat >> /etc/sysctl.d/99-vps-tuning.conf << 'SYSCTLEOF'

# TCP keep-alive for long-lived connections
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 60
net.ipv4.tcp_keepalive_probes = 3

# Reduce TIME_WAIT sockets
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_max_tw_buckets = 262144

# SYN protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 8192

# TCP Fast Open
net.ipv4.tcp_fastopen = 3
SYSCTLEOF
  sysctl -p /etc/sysctl.d/99-vps-tuning.conf > /dev/null
  echo "  ✅ Network tuning applied"
else
  echo "  ⏭️  Network tuning already applied"
fi

# Phase 7: fail2ban Enhancement
echo "📋 Phase 7: Enhancing fail2ban..."
if [ -f /etc/fail2ban/jail.local ]; then
  if ! grep -q "bantime.increment" /etc/fail2ban/jail.local; then
    sed -i '/^[DEFAULT]/a bantime.increment = truenbantime.multipliers = 1 2 4 8 16 32 64nbantime.maxtime = 4w\ /etc/fail2ban/jail.local
    fail2ban-client reload > /dev/null
    echo "  ✅ fail2ban enhanced with incremental bans"
  else
    echo "  ⏭️  fail2ban already has incremental bans"
  fi
else
  echo "  ⚠️  No /etc/fail2ban/jail.local found - skipping"
fi

echo ""
echo "🎉 Server Optimization Complete!"
echo "================================"
echo ""
echo "✅ Swap: 2GB configured"
echo "✅ Auto-updates: Optimized with cleanup"
echo "✅ Resource limits: 65536 file descriptors"
echo "✅ Journald: Limited to 100MB"
echo "✅ SSH: Hardened with keep-alive"
echo "✅ Network: TCP optimizations applied"
echo "✅ fail2ban: Incremental bans enabled"
echo ""
echo "📊 Verification:"
echo "  - Swap:       swapon --show"
echo "  - Limits:     ulimit -n (in new shell)"
echo "  - Journal:    journalctl --disk-usage"
echo "  - fail2ban:   fail2ban-client status sshd"
echo ""
echo "⚠️  Note: Resource limits take effect on next login"
echo "🔄 Reboot recommended but not required"
