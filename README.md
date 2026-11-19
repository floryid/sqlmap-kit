<div align="center">

<!-- Animated banner (ASCII) -->
```
 ███████╗ ██████╗ ██╗     ███╗   ███╗ █████╗ ██████╗     ██╗  ██╗██╗████████╗
 ██╔════╝██╔═══██╗██║     ████╗ ████║██╔══██╗██╔══██╗    ██║ ██╔╝██║╚══██╔══╝
 ███████╗██║   ██║██║     ██╔████╔██║███████║██████╔╝    █████╔╝ ██║   ██║
 ╚════██║██║▄▄ ██║██║     ██║╚██╔╝██║██╔══██║██╔═══╝     ██╔═██╗ ██║   ██║
 ███████║╚██████╔╝███████╗██║ ╚═╝ ██║██║  ██║██║         ██║  ██╗██║   ██║
 ╚══════╝ ╚══▀▀═╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝         ╚═╝  ╚═╝╚═╝   ╚═╝
```

### The Ultimate Interactive SQLMap Orchestrator

**A hacker-themed, fully interactive wrapper for `sqlmap` — with animated UI, 40+ flags,
7 modules, and production-grade session management.**

[![Shell](https://img.shields.io/badge/shell-bash-4.4%2B-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/version-2.1-blue?style=for-the-badge)](https://github.com/Pixel-Detective/sqlmap_kit/releases)
[![License](https://img.shields.io/badge/license-MIT-yellow?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Termux-orange?style=for-the-badge)](https://github.com/Pixel-Detective/sqlmap_kit)

[![Stars](https://img.shields.io/github/stars/Pixel-Detective/sqlmap_kit?style=social)](https://github.com/Pixel-Detective/sqlmap_kit/stargazers)
[![Forks](https://img.shields.io/github/forks/Pixel-Detective/sqlmap_kit?style=social)](https://github.com/Pixel-Detective/sqlmap_kit/network/members)
[![Issues](https://img.shields.io/github/issues/Pixel-Detective/sqlmap_kit?style=social)](https://github.com/Pixel-Detective/sqlmap_kit/issues)

</div>

---

> [!WARNING]
> **⚖️ LEGAL NOTICE — READ BEFORE USE**
>
> This tool is intended **strictly for authorized penetration testing**,
> **CTF challenges**, and **educational purposes**.
>
> You **MUST** have **explicit written permission (Rules of Engagement)** from the
> target system owner before running this tool against any target.
>
> **Unauthorized use of this tool against systems you do not own is ILLEGAL** in most
> jurisdictions and may result in severe criminal penalties (in Indonesia: **UU ITE
> Pasal 30 & 46**). The author (**Pixel_Detective**) assumes **NO liability** for any
> misuse, damage, or illegal activity. **You are solely responsible for your actions.**

---

## 📑 Table of Contents

- [✨ Features](#-features)
- [📸 Screenshots](#-screenshots)
- [🏗️ Architecture](#️-architecture)
- [🔧 Requirements](#-requirements)
- [📦 Installation](#-installation)
- [🚀 Usage](#-usage)
- [🧩 Modules](#-modules)
- [⚙️ Configuration](#️-configuration)
- [💡 Examples](#-examples)
- [🐛 Troubleshooting](#-troubleshooting)
- [🗺️ Roadmap](#️-roadmap)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [👤 Author](#-author)
- [🇮🇩 Bahasa Indonesia](#-bahasa-indonesia)

---

## ✨ Features

<table>
<tr>
<td width="50%" valign="top">

### 🎨 UI / UX
- ✅ **Animated boot sequence** — matrix rain, glitch reveal, rainbow typewriter
- ✅ **Truecolor → 256 → 16 color auto-detection**
- ✅ **Gradient loading bars + braille spinner**
- ✅ **Boxed HUD banners** with per-line gradient ASCII
- ✅ **Emoji status icons** (✔ ⚠ ✘ ➜ ❯)
- ✅ **Auto-fallback** to no-color / no-animation when not in TTY

</td>
<td width="50%" valign="top">

### 🧠 Engineering
- ✅ **Array-based arg builder** — no more word-splitting bugs
- ✅ **Safe session persistence** (`printf %q` round-trip)
- ✅ **Numeric input validation** (`ask_int` with min/max)
- ✅ **Ctrl+C trap** — always restores cursor
- ✅ **Log auto-rotation** at 5 MB
- ✅ **`set -uo pipefail`** + ERR-safe workflow

</td>
</tr>
<tr>
<td valign="top">

### 🔐 Exploitation
- ✅ 40+ `sqlmap` flags exposed
- ✅ `--sql-shell` / `--os-shell` / `--os-pwn`
- ✅ `--file-read` / `--file-write`
- ✅ `--reg-read` (Windows registry)
- ✅ Reverse shell generator
- ✅ Tamper-script presets (WAF bypass)

</td>
<td valign="top">

### 🕵️ Recon & Reporting
- ✅ WAF detection (`wafw00f` + `--check-waf`)
- ✅ XSS / LFI reflection probes
- ✅ Nmap fast scan
- ✅ Security-header analysis
- ✅ **Reports in Markdown / JSON / HTML**
- ✅ **Multi-format session export**

</td>
</tr>
</table>

---

## 📸 Screenshots

> _Screenshots below use `SQLMAP_KIT_FAST=1` for brevity._

### Boot sequence
```
  ➜ Bootstrapping kernel      ✔
  ➜ Loading SQLi engine       [██████████████████████████████] 100%
  ➜ Loading color layers      [██████████████████████████████] 100%
  ➜ Mounting target hooks     [██████████████████████████████] 100%
  ➜ Linking tamper modules    ✔
```

### Main menu
```
 ╔══════════════════════════════════════════════════════════════════╗
 ║                      ▸ MAIN TERMINAL ▸                           ║
 ╚══════════════════════════════════════════════════════════════════╝
 ┌──[ CURRENT TARGET ]─────────────────────────────────────────────┐
   ➜ Target : https://example.com/api?id=1
   ➜ Method : GET
   ➜ L/R/T  : 3 / 2 / 5
   ➜ DBMS   : mysql
 └─────────────────────────────────────────────────────────────────┘
 ──────────────────────────────────────────────────────────────────

   s) Setup Target & Environment
   l) Load Last Session
   ─────────────────────────────────────────────────────
   1) Recon & Vuln Scanner      (WAF/XSS/LFI/Nmap/Headers)
   2) SQL Injection & Enumeration
   3) Data Extraction (Dump)
   4) Post-Exploitation          (shell/upload/os-cmd)
   5) Advanced & Evasion         (proxy/tor/auth/tamper)
   6) Reports & Logs
   7) Utilities
   ─────────────────────────────────────────────────────
   !) Exit

   Pixel_Detective ▸ _
```

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        SQLMAP_KIT v2.1                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────┐   ┌────────────┐   ┌────────────┐                │
│  │  BOOT UI   │──▶│  MAIN MENU │──▶│   MODULES  │                │
│  │ (animated) │   │  (HUD)     │   │ (7 total)  │                │
│  └────────────┘   └─────┬──────┘   └─────┬──────┘                │
│                          │                 │                     │
│                          ▼                 ▼                     │
│                  ┌──────────────┐  ┌──────────────┐              │
│                  │   SESSION    │  │  ARG BUILDER │              │
│                  │  (~/.sqlmap) │  │  (bash array)│              │
│                  └──────┬───────┘  └──────┬───────┘              │
│                         │                 │                      │
│                         ▼                 ▼                      │
│                  ┌────────────────────────────────┐              │
│                  │   run_sqlmap() — safe exec     │              │
│                  └─────────────┬──────────────────┘              │
│                                │                                 │
│                                ▼                                 │
│                  ┌────────────────────────────────┐              │
│                  │   sqlmap (subprocess)          │              │
│                  └─────────────┬──────────────────┘              │
│                                │                                 │
│                                ▼                                 │
│                  ┌────────────────────────────────┐              │
│                  │   OUTPUT / DUMP / LOG / REPORT │              │
│                  └────────────────────────────────┘              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Requirements

| Dependency | Version | Required | Purpose |
|-----------|---------|:--------:|---------|
| `bash` | ≥ 4.4 | ✅ | Array, `printf %q` |
| `sqlmap` | any recent | ✅ | The engine |
| `python3` | ≥ 3.7 | ⚠️ | `url_encode`, `--eval` |
| `curl` | any | ⚠️ | Recon probes |
| `jq` | any | 💡 | JSON reports |
| `wafw00f` | any | 💡 | WAF detection |
| `nmap` | any | 💡 | Port scan |
| `msfconsole` | any | 💡 | `--os-pwn` |

**Legend:** ✅ required · ⚠️ recommended · 💡 optional

---

## 📦 Installation

### 1️⃣ Via `git clone` (recommended)

```bash
git clone https://github.com/Pixel-Detective/sqlmap_kit.git
cd sqlmap_kit
chmod +x sqlmap_kit.sh
./sqlmap_kit.sh --check
```

### 2️⃣ Via `curl` (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/Pixel-Detective/sqlmap_kit/main/sqlmap_kit.sh \
     -o sqlmap_kit.sh && chmod +x sqlmap_kit.sh
```

### 3️⃣ Install dependencies

<details>
<summary><b>🐉 Kali / Debian / Ubuntu</b></summary>

```bash
sudo apt update
sudo apt install -y sqlmap python3 curl jq nmap
pip install wafw00f --break-system-packages
```
</details>

<details>
<summary><b>🍎 macOS (Homebrew)</b></summary>

```bash
brew install sqlmap python curl jq nmap
pip3 install wafw00f
```
</details>

<details>
<summary><b>📱 Termux (Android)</b></summary>

```bash
pkg update && pkg upgrade -y
pkg install -y python curl jq nmap git
pip install sqlmap wafw00f
git clone https://github.com/Pixel-Detective/sqlmap_kit.git
cd sqlmap_kit && chmod +x sqlmap_kit.sh && ./sqlmap_kit.sh
```
</details>

<details>
<summary><b>🐳 Docker</b></summary>

```dockerfile
FROM kalilinux/kali-rolling
RUN apt update && apt install -y sqlmap python3 curl jq nmap git \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /opt
RUN git clone https://github.com/Pixel-Detective/sqlmap_kit.git
WORKDIR /opt/sqlmap_kit
RUN chmod +x sqlmap_kit.sh
ENTRYPOINT ["./sqlmap_kit.sh"]
```
</details>

---

## 🚀 Usage

### Basic

```bash
./sqlmap_kit.sh              # interactive mode
./sqlmap_kit.sh --check      # verify dependencies
./sqlmap_kit.sh --help       # help
```

### With animation control

```bash
# Disable all animations (CI, logs, screen recording)
SQLMAP_KIT_NO_ANIM=1 ./sqlmap_kit.sh

# Speed up animations 3× (demos)
SQLMAP_KIT_FAST=1 ./sqlmap_kit.sh
```

### Workflow

```
┌──────────────────┐
│  1. SETUP TARGET │──▶ fill URL, method, cookie, level/risk/threads
└────────┬─────────┘
         ▼
┌──────────────────┐
│ 2. RECON (opt.)  │──▶ WAF? XSS? LFI? open ports?
└────────┬─────────┘
         ▼
┌──────────────────┐
│  3. ENUMERATE    │──▶ banner, user, dbs, tables, columns
└────────┬─────────┘
         ▼
┌──────────────────┐
│   4. DUMP DATA   │──▶ targeted or full-dump
└────────┬─────────┘
         ▼
┌──────────────────┐
│ 5. POST-EXPLOIT  │──▶ files / OS cmd / shell (AUTHORIZED only!)
└────────┬─────────┘
         ▼
┌──────────────────┐
│  6. REPORT OUT   │──▶ MD / JSON / HTML
└──────────────────┘
```

---

## 🧩 Modules

| # | Module | Description |
|:-:|--------|-------------|
| **1** | 🔍 Recon & Vuln Scanner | WAF detection, XSS/LFI probes, Nmap, headers, robots.txt, wizard |
| **2** | 💉 SQL Injection & Enumeration | Basic scan, `--banner/--dbs/--tables`, technique override, tamper |
| **3** | 🗄️ Data Extraction | `--dump`, `--sql-query`, `--sql-shell`, `--search` |
| **4** | 💀 Post-Exploitation | `--file-read/write`, `--os-cmd/shell/pwn`, `--reg-read` |
| **5** | 🥷 Advanced & Evasion | Proxy, Tor, auth, CSRF, chunked, force-ssl, `--eval`, raw args |
| **6** | 📊 Reports & Logs | Live log tail, MD/JSON/HTML export, clear state |
| **7** | 🧰 Utilities | Update, version, help dump, clear cache, Tor check |

---

## ⚙️ Configuration

### Session file
```
~/.sqlmap_kit/session.env     ← auto-saved target config
~/.sqlmap_kit/activity.log    ← command history (auto-rotates @ 5MB)
~/.sqlmap_kit/reports/        ← generated reports
```

### Environment variables

| Variable | Default | Effect |
|----------|---------|--------|
| `SQLMAP_KIT_NO_ANIM` | `0` | `1` = disable all animations |
| `SQLMAP_KIT_FAST` | `0` | `1` = 3× faster animations |
| `COLORTERM` | auto | `truecolor` enables 24-bit palette |
| `TERM` | auto | `*256color*` enables 256 palette |

### Advanced flags (via Module 5)

```bash
--level 1..5            # depth of tests
--risk  1..3            # risk of payload damage
--threads 1..20         # parallel threads
--delay N               # wait N sec between requests
--timeout N             # per-request timeout
--retries N             # retry count
--tamper a,b,c          # WAF bypass scripts
--dbms mysql            # force DBMS
--technique B/E/U/S/T   # force injection technique
--random-agent          # random User-Agent
--parse-errors          # parse DBMS errors
--hex                   # hex-encode payloads
--chunked               # HTTP chunked transfer
--force-ssl             # force HTTPS
--tor --check-tor       # route via Tor
--proxy http://...      # custom proxy
--proxy-file path       # proxy list file
--auth-type Basic       # auth type
--auth-cred user:pass   # auth credentials
--csrf-token name       # CSRF token param
--csrf-url url          # CSRF token URL
--eval "python code"    # pre-eval hook
```

---

## 💡 Examples

### Example 1 — Simple GET injection

```bash
./sqlmap_kit.sh
# choose: s → set URL https://testphp.vulnweb.com/artists.php?artist=1
# choose: 2 → 1 (basic scan)
# choose: 2 → 2 (enumerate)
# choose: 3 → 1 (dump a table)
```

### Example 2 — Authenticated POST with cookie

```bash
./sqlmap_kit.sh
# s   → URL: https://target.com/login.php
#     → Method: POST
#     → Data:   user=admin&pass=123
#     → Cookie: (paste PHPSESSID=...)
# 2 → 1 (scan) → if injectable → 3 → 4 (sql-shell)
```

### Example 3 — WAF bypass with tamper

```bash
# inside module 2 → option 5
#   choose: 2 (space2comment,randomcase,between)
```

### Example 4 — Burp proxy chain

```bash
# module 5 → option 1 → Burp (127.0.0.1:8080)
# every subsequent scan routes through Burp
```

### Example 5 — Full automation (CI/cron)

```bash
SQLMAP_KIT_NO_ANIM=1 ./sqlmap_kit.sh <<'EOF'
s
https://testphp.vulnweb.com/artists.php?artist=1
GET


3
2
5
1
mysql
1
0


0
3
1


2
3
EOF
```

---

## 🐛 Troubleshooting

<details>
<summary><b>❌ "sqlmap: command not found"</b></summary>

Install via:
```bash
sudo apt install sqlmap          # Debian/Kali
pip install sqlmap --break-system-packages   # generic
pkg install sqlmap               # Termux
```
</details>

<details>
<summary><b>❌ Colors look wrong / no colors</b></summary>

Check terminal capability:
```bash
echo "$TERM"          # should be xterm-256color or screen-256color
echo "$COLORTERM"     # truecolor for 24-bit
```
Force 256-color mode: `export TERM=xterm-256color`
</details>

<details>
<summary><b>❌ Animations are laggy</b></summary>

```bash
SQLMAP_KIT_FAST=1 ./sqlmap_kit.sh     # 3× faster
SQLMAP_KIT_NO_ANIM=1 ./sqlmap_kit.sh  # instant
```
</details>

<details>
<summary><b>❌ Cursor disappeared after Ctrl+C</b></summary>

Fixed in v2.1 via `trap ... printf SHOW`. Manual restore:
```bash
printf '\033[?25h'
```
</details>

<details>
<summary><b>❌ "session file corrupt"</b></summary>

```bash
rm ~/.sqlmap_kit/session.env
./sqlmap_kit.sh     # new session
```
</details>

<details>
<summary><b>❌ Tor check fails</b></summary>

```bash
sudo systemctl start tor          # start service
curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip
```
</details>

---

## 🗺️ Roadmap

- [x] **v1.0** — Initial interactive SQLMap wrapper
- [x] **v2.0** — Full rewrite: array args, 7 modules, MD/JSON/HTML reports
- [x] **v2.1** — Animated hacker UI, truecolor, boot sequence, Ctrl+C trap
- [ ] **v2.2** — Multi-target parallel runner (`targets.txt`)
- [ ] **v2.3** — Slack/Discord webhook notifications
- [ ] **v2.4** — HTML dashboard report (embedded timeline)
- [ ] **v3.0** — Plugin system + YAML playbooks

---

## 🤝 Contributing

Contributions welcome! Please:

1. **Fork** the repo
2. Create your branch: `git checkout -b feature/my-feature`
3. **Test** your change locally (`shellcheck sqlmap_kit.sh`)
4. **Commit**: `git commit -m 'Add my-feature'`
5. **Push**: `git push origin feature/my-feature`
6. Open a **Pull Request**

### Coding standards
- `shellcheck -S warning` clean
- Keep functions under 80 lines
- Document every public function with `# usage:` comment
- Add `press_enter` at end of every menu loop

---

## 📄 License

```
MIT License

Copyright (c) 2025 Pixel_Detective

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👤 Author

<div align="center">

**Pixel_Detective**

[![GitHub](https://img.shields.io/badge/GitHub-%40Pixel--Detective-181717?style=for-the-badge&logo=github)](https://github.com/Pixel-Detective)
[![Email](https://img.shields.io/badge/Email-pixel%40example.com-D14836?style=for-the-badge&logo=gmail)](mailto:pixel@example.com)

> _"Security through education, not exploitation."_

</div>

---

## 🙏 Credits

- **[sqlmap](https://github.com/sqlmapproject/sqlmap)** by Bernardo Damele & Miroslav Štampar — the engine that does the real work.
- **[wafw00f](https://github.com/EnableSecurity/wafw00f)** — WAF fingerprinting.
- **[shellcheck](https://www.shellcheck.net/)** — for catching 30+ bugs during rewrite.
- All **CTF players** and **bug bounty hunters** who keep this craft honest.

---

## 🇮🇩 Bahasa Indonesia

<details>
<summary><b>Klik untuk membaca versi Bahasa Indonesia</b></summary>

### 📌 Ringkasan

**SQLMAP_KIT** adalah wrapper interaktif untuk `sqlmap` dengan UI beranimasi
bertema hacker, 40+ flag, 7 modul, dan manajemen sesi yang aman.

### ⚡ Quick Start

```bash
git clone https://github.com/Pixel-Detective/sqlmap_kit.git
cd sqlmap_kit && chmod +x sqlmap_kit.sh
./sqlmap_kit.sh --check
./sqlmap_kit.sh
```

### 🧩 Modul

1. **Recon & Vuln Scanner** — WAF, XSS, LFI, Nmap
2. **SQL Injection & Enumeration** — scan, dbs, tables
3. **Data Extraction** — dump, sql-query, sql-shell
4. **Post-Exploitation** — file-read, os-shell, reverse shell
5. **Advanced & Evasion** — proxy, tor, tamper, auth
6. **Reports & Logs** — MD / JSON / HTML
7. **Utilities** — update, version, clear cache

### ⚠️ Peringatan

> **Tool ini HANYA untuk pentest resmi, CTF, dan edukasi.**
>
> Dilarang keras digunakan terhadap sistem tanpa izin tertulis.
> Pelanggaran dapat dikenai **UU ITE Pasal 30 & 46** (pidana hingga
> **6 tahun penjara** / denda **Rp 600 juta**).
>
> **Anda bertanggung jawab penuh atas segala penyalahgunaan.**

### 🎛️ Kontrol Animasi

```bash
SQLMAP_KIT_NO_ANIM=1 ./sqlmap_kit.sh   # tanpa animasi
SQLMAP_KIT_FAST=1    ./sqlmap_kit.sh   # animasi 3× cepat
```

### 📊 Output

- **Session** → `~/.sqlmap_kit/session.env`
- **Log** → `~/.sqlmap_kit/activity.log` (auto-rotate @ 5MB)
- **Report** → `~/.sqlmap_kit/reports/report_*.{md,json,html}`
- **Dump** → `./dump/<host>_<ts>/`
- **Output** → `./out/<host>_<ts>/`

</details>

---

<div align="center">

**⭐ If this tool helped you during a pentest or CTF, please drop a star! ⭐**

<sub>Made with 🖤 and lots of `bash` by Pixel_Detective · 2025</sub>

<sub>**Remember:** With great power comes great responsibility. Hack ethically. 🛡️</sub>

</div>