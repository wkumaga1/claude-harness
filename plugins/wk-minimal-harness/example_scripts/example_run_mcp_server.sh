#!/usr/bin/env bash
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:?}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

RUNTIME_DIR="${PROJECT_DIR}/.claude/runtime/mcp/wk-example-stdio"
VENV_DIR="${RUNTIME_DIR}/venv"
SERVER_PY="${PLUGIN_ROOT}/example_mcp_servers/example_mcp_server.py"

# Optional: load project .env for the MCP server process (do not print)
DOTENV="${PROJECT_DIR}/.env"
if [[ -f "${DOTENV}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${DOTENV}"
  set +a
fi

# Do NOT install here; assume SessionStart prepared it.
# If missing, fail with stderr message (stdout must stay clean).
if [[ ! -x "${VENV_DIR}/bin/python" ]]; then
  echo "[ERROR] MCP venv missing. Run SessionStart (or example_mcp_venv_setup.sh) first." >&2
  exit 1
fi

exec "${VENV_DIR}/bin/python" "${SERVER_PY}"
