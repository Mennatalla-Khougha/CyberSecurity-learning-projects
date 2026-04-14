# 🛡️ Project 1.1 — Build Your Hacking Lab
**Phase:** 01 — Foundations  
**Status:** 🔄 In Progress  
**Started:** 14/04/2026  
**Completed:** N/A  

---

## 📋 Overview
Set up a safe, isolated VM lab on your Linux machine where you can attack and defend without risk. This is the foundation for everything else in the roadmap.

**VMs you'll have by end of this project:**
- Kali Linux (attacker machine)
- Metasploitable2 (victim machine)
- Both on an isolated internal network (no internet access for victim)

---

## 🗂️ Topic 1 — Virtualization & Networking Setup

**Status:** ✅ Completed  
**Started:** 14/04/2026  
**Completed:** 14/04/2026  

### ✅ Tasks
- [✅] Install VirtualBox on Ubuntu host
- [✅] Download Kali Linux iso image from kali.org
- [✅] Import Kali into VirtualBox and boot it up
- [✅] Download Metasploitable2 from SourceForge
- [✅] Import Metasploitable2 into VirtualBox
- [✅] Create a Host-Only network adapter in VirtualBox
- [✅] Attach BOTH VMs to the Host-Only adapter
- [✅] Boot both VMs — confirm Kali can ping Metasploitable2
- [✅] Confirm Metasploitable2 CANNOT reach 8.8.8.8 (internet blocked)
- [✅] Take a snapshot of BOTH VMs (so you can restore after experiments)

### 🎯 Acceptance Criteria
> ✔ Kali pings Metasploitable2 successfully  
> ✔ Metasploitable2 cannot reach 8.8.8.8  
> ✔ Both VMs are snapshotted and restorable  
> ✔ You can explain the difference between NAT, Bridged, and Host-Only networking from memory  

### 📝 Notes / Blockers
- When I create the Kali Vm and boot it for the first time. I must set NAT network then after it boot up for the first time I can change it to Host-Only network.
- For Metasploitable2 Vm, the following setting: 
    - Settings → System → Motherboard: ❌ Uncheck Enable I/O APIC
    - Settings → System → Motherboard: RAM size 512MB
    - Settings → System → Processor: ✅ Check Enable PAE/NX
    - Settings → System → Processor: 1 CPU
    - Setting → System → Acceleration: Paravirtualization: Legacy
- Network NAT: Allow direct access to host network but other vm can't access it.
- Network Host-Only: Private Network No Network access to internet but other vm can access it.
- Network Bridged: Allow direct access to host network and other vm can access it "The VM become a full device on the network".


### 🔗 Verified Free Resources

| Resource | URL | What it covers |
|---|---|---|
| Kali Linux VirtualBox Guide (Official) | https://www.kali.org/docs/virtualization/install-virtualbox-guest-vm/ | Installing Kali as a VirtualBox guest VM |
| How to Build a Private Hacking Lab (freeCodeCamp) | https://www.freecodecamp.org/news/build-a-private-hacking-lab-with-virtualbox/ | Full lab setup: Kali + VulnHub target + host-only network |
| Setup Hacking Lab with Metasploitable (GoLinuxCloud) | https://www.golinuxcloud.com/setup-hacking-lab-with-metasploitable/ | Importing Metasploitable2 into VirtualBox step by step |
| How to Create a Virtual Hacking Lab (StationX) | https://www.stationx.net/how-to-create-a-virtual-hacking-lab/ | Multi-VM lab, snapshots, network adapter config |
| VirtualBox NAT Network Setup (Medium) | https://medium.com/@dancovic/set-up-a-hacking-lab-based-on-nat-networks-virtualbox-networking-fa4a1a0dc6f1 | VirtualBox network types explained with steps |
| Metasploitable2 Download | https://sourceforge.net/projects/metasploitable/ | Direct download of the VM image |

---

## 🗂️ Topic 2 — Linux Security Hardening Basics

### ✅ Tasks
- [ ] Run `ss -tulpn` on your Ubuntu host — list all open ports and running services
- [ ] Find all SUID binaries: `find / -perm -u=s -type f 2>/dev/null`
- [ ] Create a new non-root user with `adduser`
- [ ] Generate SSH keypair: `ssh-keygen -t ed25519`
- [ ] Set up SSH key auth for the new user
- [ ] Disable SSH password login in `/etc/ssh/sshd_config`
- [ ] Disable root SSH login in `/etc/ssh/sshd_config`
- [ ] Install and configure `ufw`: deny all incoming, allow only SSH
- [ ] Read `/var/log/auth.log` — identify failed login attempts
- [ ] Write a bash script that automates your hardening checklist
- [ ] Save the script to your GitHub

### 🎯 Acceptance Criteria
> ✔ Your hardening script runs cleanly without errors  
> ✔ SSH only accepts key-based auth (password login rejected)  
> ✔ UFW is active and rules are correct (`ufw status verbose`)  
> ✔ You have a written checklist of 10+ security items you audited  
> ✔ You can explain what each firewall rule does  

### 📝 Notes / Blockers
```
<!-- write your notes here -->
```

### 🔗 Verified Free Resources

| Resource | URL | What it covers |
|---|---|---|
| Initial Server Setup with Ubuntu (DigitalOcean) | https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu | Users, SSH keys, firewall — exact tasks you need |
| Linux File Permissions Explained (LinuxHandbook) | https://linuxhandbook.com/linux-file-permissions/ | Permissions, SUID, chmod — security-focused |
| Intro to Linux Permissions (DigitalOcean) | https://www.digitalocean.com/community/tutorials/an-introduction-to-linux-permissions | Users, groups, file ownership concepts |
| SUID, SGID, Sticky Bit (LinuxHandbook) | https://linuxhandbook.com/suid-sgid-sticky-bit/ | Special permissions — critical for PrivEsc later |
| TryHackMe Linux Fundamentals 1 | https://tryhackme.com/room/linuxfundamentalspart1 | Hands-on Linux basics (free, no VPN needed for first room) |
| TryHackMe Linux Fundamentals 2 | https://tryhackme.com/room/linuxfundamentalspart2 | File permissions, users, processes |
| TryHackMe Linux Fundamentals 3 | https://tryhackme.com/room/linuxfundamentalspart3 | Automation, services, logs |

---

## 🗂️ Topic 3 — Python for Security Scripting (Port Scanner Project)

### ✅ Tasks
- [ ] Read the socket module basics in Python docs
- [ ] Build a basic TCP port scanner using Python sockets (no libraries, raw sockets only)
- [ ] Test it against localhost first
- [ ] Add Python `threading` to scan multiple ports simultaneously
- [ ] Add banner grabbing: connect to open port and read what the service responds
- [ ] Save results to a JSON file as a report
- [ ] Test the full scanner against your Metasploitable2 VM
- [ ] Push the code to GitHub with a proper README
- [ ] Benchmark: scanner should finish ports 1-1024 in under 30 seconds

### 🎯 Acceptance Criteria
> ✔ Scanner scans ports 1–1024 on Metasploitable2 in under 30 seconds  
> ✔ Banner grabbing works — you see service responses (e.g. "SSH-2.0-OpenSSH_4.7p1")  
> ✔ Output is saved as a JSON report file  
> ✔ Code is on GitHub with a README that explains how to use it  
> ✔ You can explain what a TCP socket is and what `connect()` does under the hood  

### 📝 Notes / Blockers
```
<!-- write your notes here -->
```

### 🔗 Verified Free Resources (all tested and working)

| Resource | URL | What it covers |
|---|---|---|
| Python Sockets Tutorial (RealPython) | https://realpython.com/python-sockets/ | Deep dive into Python socket programming — the best reference |
| Port Scanner in Python (thepythoncode.com) | https://thepythoncode.com/article/make-port-scanner-python | Simple + threaded port scanner with full code |
| Port Scanner in Python (GeeksforGeeks) | https://www.geeksforgeeks.org/port-scanner-using-python/ | Step by step with threading, good for beginners |
| Python Port Scanner with Threading (TutorialsPoint) | https://www.tutorialspoint.com/python_penetration_testing/python_penetration_testing_network_scanner.htm | Threading approach with Queue — solid reference |
| Python Socket Docs (Official) | https://docs.python.org/3/library/socket.html | Official reference — use alongside the tutorials |
| Simple Port Scanner Example (GitHub) | https://github.com/ArtDesa/SimplePortScanner | Reference implementation to compare your code against |

---

## 📊 Overall Progress

| Topic | Status | Completion |
|---|---|---|
| Topic 1: Virtualization & Lab Setup | 🔲 Not Started | 0% |
| Topic 2: Linux Security Hardening | 🔲 Not Started | 0% |
| Topic 3: Python Port Scanner | 🔲 Not Started | 0% |

**Legend:** 🔲 Not Started · 🔄 In Progress · ✅ Complete · ❌ Blocked

---

## 🗃️ Deliverables Checklist
> Things that should exist when this project is **done**:

- [ ] Kali + Metasploitable2 lab running and snapshotted
- [ ] Network diagram of your lab (hand-drawn or digital, doesn't matter)
- [ ] Bash hardening script pushed to GitHub
- [ ] Python port scanner pushed to GitHub with README
- [ ] JSON report file generated from scanning Metasploitable2
- [ ] Personal notes written (Obsidian, Notion, or markdown file)

---

## 💡 What You Learn From This Project

By completing Project 1.1 you will be able to:

- Set up and manage isolated VM environments for security testing
- Explain VM networking modes (NAT vs Host-Only vs Bridged) and when to use each
- Audit a Linux system for common security misconfigurations
- Configure SSH hardening and UFW firewall rules
- Read and interpret system logs (`auth.log`, `syslog`)
- Write a functional network tool in Python using raw sockets
- Understand what TCP connection establishment looks like at the code level

These are skills you can talk about in a job interview on day one.

---

*Tracker for Cybersecurity Roadmap — Phase 01, Project 1.1*  
*Last updated: <!-- fill in -->*
