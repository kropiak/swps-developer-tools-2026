#!/usr/bin/env bash
# ==============================================================================
# Developer Tools — Lab 03: Self-Verification Script (verify_lab03.sh)
# ==============================================================================

# Detect whether the user is running the script from repo root or inside workspace/
if [ -d "workspace" ]; then
    WDIR="workspace"
elif [ -f ".secret_note" ] || [ -d "src" ]; then
    WDIR="."
else
    echo "[ERROR] Cannot find 'workspace' directory. Run 'bash setup_lab03.sh' first."
    exit 1
fi

PASS=0
FAIL=0

check() {
    local description="$1"
    local condition="$2"
    if eval "$condition"; then
        echo "  [OK]   $description"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] $description"
        FAIL=$((FAIL + 1))
    fi
}

echo "=================================================="
echo " Verifying Lab 03 Tasks in: ${WDIR}"
echo "=================================================="

echo ""
echo "--- Part 2: Directory Structure & Cleanup ---"
check "Directories src, docs, config, logs, reports exist" \
    "[ -d '$WDIR/src' ] && [ -d '$WDIR/docs' ] && [ -d '$WDIR/config' ] && [ -d '$WDIR/logs' ] && [ -d '$WDIR/reports' ]"

check "Python files (*.py) moved to src/" \
    "[ -f '$WDIR/src/main.py' ] && [ -f '$WDIR/src/utils.py' ] && [ -f '$WDIR/src/database.py' ] && [ -f '$WDIR/src/auth_helper.py' ]"

check "Markdown docs (*.md) moved to docs/" \
    "[ -f '$WDIR/docs/API.md' ] && [ -f '$WDIR/docs/INSTALL.md' ] && [ -f '$WDIR/docs/CHANGELOG.md' ]"

check "Config files (*.conf and .env.example) moved to config/" \
    "[ -f '$WDIR/config/app.conf' ] && [ -f '$WDIR/config/db.conf' ] && [ -f '$WDIR/config/.env.example' ]"

check "Log files (*.log) moved to logs/" \
    "[ -f '$WDIR/logs/app.log' ] && [ -f '$WDIR/logs/access.log' ]"

TMP_COUNT=$(find "$WDIR" -name "*.tmp" -o -name "*.bak" 2>/dev/null | wc -l)
check "All temporary (*.tmp) and backup (*.bak) files removed" \
    "[ '$TMP_COUNT' -eq 0 ]"

echo ""
echo "--- Part 3: Redirections & Pipes (Log Analysis) ---"
check "File reports/errors_only.log exists and has 6 ERROR lines" \
    "[ -f '$WDIR/reports/errors_only.log' ] && [ \$(wc -l < '$WDIR/reports/errors_only.log') -eq 6 ]"

check "File reports/incident_report.txt exists and includes top IP (192.168.1.50)" \
    "[ -f '$WDIR/reports/incident_report.txt' ] && grep -q '192.168.1.50' '$WDIR/reports/incident_report.txt'"

echo ""
echo "--- Part 4: Terminal Text Editors (nano & vim) ---"
check "config/app.conf has DEBUG=false and PORT=9000" \
    "[ -f '$WDIR/config/app.conf' ] && grep -q '^DEBUG=false' '$WDIR/config/app.conf' && grep -q '^PORT=9000' '$WDIR/config/app.conf'"

check "config/app.conf has MAINTAINER updated (not TODO)" \
    "[ -f '$WDIR/config/app.conf' ] && grep -q '^MAINTAINER=' '$WDIR/config/app.conf' && ! grep -q '^MAINTAINER=TODO' '$WDIR/config/app.conf'"

check "reports/incident_report.txt includes SECRET_TOKEN (LINUX_EXPLORER_2026)" \
    "[ -f '$WDIR/reports/incident_report.txt' ] && grep -q 'LINUX_EXPLORER_2026' '$WDIR/reports/incident_report.txt'"

echo ""
echo "=================================================="
echo " Summary: ${PASS} passed, ${FAIL} failed"
echo "=================================================="

if [ "$FAIL" -eq 0 ]; then
    echo "Congratulations! All checks passed. Remember to commit and push your repository to GitHub!"
    exit 0
else
    echo "Some checks are still failing. Review the items marked [FAIL] above."
    exit 1
fi
