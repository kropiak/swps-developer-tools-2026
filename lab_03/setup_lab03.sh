#!/usr/bin/env bash
# ==============================================================================
# Developer Tools — Lab 03: Linux Terminal & Shell Essentials
# Workspace generator script (setup_lab03.sh)
# ==============================================================================
set -e

TARGET_DIR="workspace"

echo "Setting up Lab 03 messy project in ./${TARGET_DIR} ..."

# Clean up previous workspace if re-running
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}/old_stuff"
mkdir -p "${TARGET_DIR}/cache_dir"

# 1. Hidden files
cat << 'EOF' > "${TARGET_DIR}/.secret_note"
==================================================
INTERNAL DEVELOPER NOTE (DO NOT DELETE)
==================================================
If you found this hidden file using 'ls -a', well done!
Keep this token for your final report in Part 4:
SECRET_TOKEN=LINUX_EXPLORER_2026
==================================================
EOF

cat << 'EOF' > "${TARGET_DIR}/.env.example"
# Environment configuration template
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
API_KEY=replace_with_production_key
EOF

# 2. Python source files (scattered in root of workspace)
cat << 'EOF' > "${TARGET_DIR}/main.py"
#!/usr/bin/env python3
"""Main entry point for legacy-service."""
from utils import format_response
from database import connect_db


def main():
    print("Starting legacy-service...")
    connect_db()
    print(format_response("OK"))


if __name__ == "__main__":
    main()
EOF

cat << 'EOF' > "${TARGET_DIR}/utils.py"
"""Utility helper functions."""


def format_response(status: str) -> str:
    return f"[STATUS]: {status}"
EOF

cat << 'EOF' > "${TARGET_DIR}/database.py"
"""Database connection module."""


def connect_db():
    return True
EOF

cat << 'EOF' > "${TARGET_DIR}/auth_helper.py"
"""Authentication helper routines."""


def verify_token(token: str) -> bool:
    return len(token) > 10
EOF

# 3. Documentation files (scattered in root of workspace)
cat << 'EOF' > "${TARGET_DIR}/API.md"
# API Documentation

## Endpoints

- `GET /api/v1/health` - Check service health
- `POST /api/v1/login` - Authenticate user
- `GET /api/v1/orders` - List customer orders
EOF

cat << 'EOF' > "${TARGET_DIR}/INSTALL.md"
# Installation Guide

1. Organize project files into proper directories.
2. Check configuration in `config/app.conf`.
3. Run `python3 src/main.py`.
EOF

cat << 'EOF' > "${TARGET_DIR}/CHANGELOG.md"
# Changelog

## [0.2.0] - 2026-11-01
- Added authentication helper
- Fixed database timeout issue

## [0.1.0] - 2026-10-15
- Initial messy prototype
EOF

# 4. Configuration files
cat << 'EOF' > "${TARGET_DIR}/app.conf"
# Application Configuration File
APP_NAME=legacy-service
ENVIRONMENT=production
PORT=8080
DEBUG=true
MAX_WORKERS=4
MAINTAINER=TODO
EOF

cat << 'EOF' > "${TARGET_DIR}/db.conf"
# Database Configuration
ENGINE=postgresql
POOL_SIZE=10
TIMEOUT_SECONDS=30
EOF

# 5. Temporary / junk files to be cleaned up
echo "Temporary crash dump 01" > "${TARGET_DIR}/crash_01.tmp"
echo "Temporary crash dump 02" > "${TARGET_DIR}/crash_02.tmp"
echo "Old backup from 2025" > "${TARGET_DIR}/old_backup.bak"
echo "Database backup copy" > "${TARGET_DIR}/db_dump.bak"
echo "Draft notes backup" > "${TARGET_DIR}/old_stuff/notes.bak"
echo "Expired session data" > "${TARGET_DIR}/old_stuff/session.tmp"
echo "Cached query result" > "${TARGET_DIR}/cache_dir/temp_data.tmp"

# 6. Log files for investigation in Part 3
cat << 'EOF' > "${TARGET_DIR}/app.log"
2026-11-10 08:00:01 INFO  [main] Starting legacy-service on port 8080
2026-11-10 08:00:02 WARN  [config] DEBUG mode is enabled in production!
2026-11-10 08:00:05 INFO  [db] Connected to PostgreSQL database (pool_size=10)
2026-11-10 08:01:12 INFO  [auth] User 'alice' logged in from 10.0.0.12
2026-11-10 08:02:44 INFO  [orders] Fetched 14 orders for user 'alice'
2026-11-10 08:05:10 WARN  [auth] Failed login attempt for user 'admin' from 192.168.1.50
2026-11-10 08:05:12 ERROR [auth] Invalid password for user 'admin' from 192.168.1.50
2026-11-10 08:05:15 ERROR [auth] Invalid password for user 'admin' from 192.168.1.50
2026-11-10 08:05:18 ERROR [auth] Account lockout triggered for IP 192.168.1.50
2026-11-10 08:06:00 INFO  [auth] User 'bob' logged in from 172.16.0.5
2026-11-10 08:07:22 INFO  [orders] Created order #1042 for user 'bob'
2026-11-10 08:10:05 WARN  [rate_limit] High request rate detected from 192.168.1.50
2026-11-10 08:10:06 ERROR [api] Unhandled exception in /api/v1/login from 192.168.1.50
2026-11-10 08:11:30 INFO  [health] Health check OK (10.0.0.1)
2026-11-10 08:12:45 INFO  [auth] User 'charlie' logged in from 10.0.0.12
2026-11-10 08:14:19 ERROR [db] Connection timeout while processing request from 192.168.1.50
2026-11-10 08:14:20 ERROR [api] HTTP 500 Internal Server Error returned to 192.168.1.50
2026-11-10 08:15:00 INFO  [health] Health check OK (10.0.0.1)
2026-11-10 08:18:11 INFO  [orders] User 'alice' logged out
2026-11-10 08:20:00 INFO  [main] Daily log rotation check completed
EOF

cat << 'EOF' > "${TARGET_DIR}/access.log"
10.0.0.12 - - [10/Nov/2026:08:01:12] "POST /api/v1/login HTTP/1.1" 200
10.0.0.12 - - [10/Nov/2026:08:02:44] "GET /api/v1/orders HTTP/1.1" 200
192.168.1.50 - - [10/Nov/2026:08:05:10] "POST /api/v1/login HTTP/1.1" 401
192.168.1.50 - - [10/Nov/2026:08:05:12] "POST /api/v1/login HTTP/1.1" 401
192.168.1.50 - - [10/Nov/2026:08:05:15] "POST /api/v1/login HTTP/1.1" 401
192.168.1.50 - - [10/Nov/2026:08:05:18] "POST /api/v1/login HTTP/1.1" 403
172.16.0.5 - - [10/Nov/2026:08:06:00] "POST /api/v1/login HTTP/1.1" 200
172.16.0.5 - - [10/Nov/2026:08:07:22] "POST /api/v1/orders HTTP/1.1" 201
172.16.0.5 - - [10/Nov/2026:08:08:10] "GET /api/v1/orders HTTP/1.1" 200
192.168.1.50 - - [10/Nov/2026:08:10:05] "POST /api/v1/login HTTP/1.1" 429
192.168.1.50 - - [10/Nov/2026:08:10:06] "POST /api/v1/login HTTP/1.1" 500
10.0.0.1 - - [10/Nov/2026:08:11:30] "GET /api/v1/health HTTP/1.1" 200
10.0.0.12 - - [10/Nov/2026:08:12:45] "POST /api/v1/login HTTP/1.1" 200
10.0.0.12 - - [10/Nov/2026:08:13:02] "GET /api/v1/orders HTTP/1.1" 200
192.168.1.50 - - [10/Nov/2026:08:14:19] "GET /api/v1/orders HTTP/1.1" 504
192.168.1.50 - - [10/Nov/2026:08:14:20] "POST /api/v1/login HTTP/1.1" 500
10.0.0.1 - - [10/Nov/2026:08:15:00] "GET /api/v1/health HTTP/1.1" 200
10.0.0.12 - - [10/Nov/2026:08:18:11] "POST /api/v1/logout HTTP/1.1" 200
EOF

echo "Done! Your messy workspace is ready in ./${TARGET_DIR}"
echo "Next step: run 'cd ${TARGET_DIR}' and follow Part 1 of the lab instructions."
