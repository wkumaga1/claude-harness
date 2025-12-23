#!/usr/bin/env bash
set -euo pipefail

# Cloud / local switch
if [[ "${CLAUDE_CODE_REMOTE:-}" = "true" ]]; then
  echo "[INFO] MCP venv setup in cloud may require network allowlist" >&2
fi

# In strict cloud environments, pip may be blocked. Allow safe early exit.
# If you want to force setup even in cloud, comment out the next 3 lines.
if [[ "${CLAUDE_CODE_REMOTE:-}" = "true" ]]; then
  exit 0
fi

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:?}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

RUNTIME_DIR="${PROJECT_DIR}/.claude/runtime/mcp/wk-example-stdio"
VENV_DIR="${RUNTIME_DIR}/venv"
REQ_FILE="${PLUGIN_ROOT}/example_python/requirements.txt"

mkdir -p "${RUNTIME_DIR}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "[WARN] python3 not found; skip MCP venv setup" >&2
  exit 0
fi

if [[ ! -x "${VENV_DIR}/bin/python" ]]; then
  python3 -m venv "${VENV_DIR}" 1>&2
fi

MARKER="${RUNTIME_DIR}/.deps_installed"
if [[ ! -f "${MARKER}" ]]; then
  "${VENV_DIR}/bin/python" -m pip install -U pip 1>&2
  "${VENV_DIR}/bin/python" -m pip install -r "${REQ_FILE}" 1>&2
  date > "${MARKER}"
fi

exit 0
