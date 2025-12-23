#!/usr/bin/env bash
set -euo pipefail

# Cloud / local switch
if [[ "${CLAUDE_CODE_REMOTE:-}" = "true" ]]; then
  echo "[INFO] CLAUDE_CODE_REMOTE=true" >&2
fi

# Only meaningful on SessionStart
if [[ -z "${CLAUDE_ENV_FILE:-}" ]]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DOTENV="${PROJECT_DIR}/.env"

# Load KEY=VALUE lines from .env (optional) and export them for subsequent Bash tool runs.
# Do not print secrets to stdout.
if [[ -f "${DOTENV}" ]]; then
  while IFS= read -r line; do
    [[ -z "${line}" ]] && continue
    [[ "${line}" =~ ^[[:space:]]*# ]] && continue
    if [[ "${line}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
      key="${line%%=*}"
      val="${line#*=}"
      echo "export ${key}=${val}" >> "${CLAUDE_ENV_FILE}"
    fi
  done < "${DOTENV}"
fi

# Ensure project-local runtime bin exists and is on PATH
RUNTIME_BIN="${PROJECT_DIR}/.claude/runtime/bin"
mkdir -p "${RUNTIME_BIN}"
echo "export PATH=\"${RUNTIME_BIN}:\$PATH\"" >> "${CLAUDE_ENV_FILE}"

exit 0
