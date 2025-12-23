#!/usr/bin/env bash
set -euo pipefail

# Cloud / local switch
if [[ "${CLAUDE_CODE_REMOTE:-}" = "true" ]]; then
  echo "[INFO] LSP bootstrap in cloud may require network allowlist" >&2
fi

# Only meaningful on SessionStart
if [[ -z "${CLAUDE_ENV_FILE:-}" ]]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
RUNTIME_DIR="${PROJECT_DIR}/.claude/runtime/lsp"
PY_VENV="${RUNTIME_DIR}/py-venv"
NODE_DIR="${RUNTIME_DIR}/node"

mkdir -p "${RUNTIME_DIR}"

# If cloud and network is restricted, allow safe early exit by default.
# If you want to force setup in cloud, comment out the next 3 lines.
if [[ "${CLAUDE_CODE_REMOTE:-}" = "true" ]]; then
  exit 0
fi

# Python LSP (pylsp)
if command -v python3 >/dev/null 2>&1; then
  if [[ ! -x "${PY_VENV}/bin/python" ]]; then
    python3 -m venv "${PY_VENV}"
  fi
  MARKER="${RUNTIME_DIR}/.pylsp_installed"
  if [[ ! -f "${MARKER}" ]]; then
    "${PY_VENV}/bin/python" -m pip install -U pip
    "${PY_VENV}/bin/python" -m pip install "python-lsp-server"
    date > "${MARKER}"
  fi
  echo "export PATH=\"${PY_VENV}/bin:\$PATH\"" >> "${CLAUDE_ENV_FILE}"
fi

# TypeScript LSP (best-effort)
if command -v npm >/dev/null 2>&1; then
  mkdir -p "${NODE_DIR}"
  MARKER_NODE="${NODE_DIR}/.tsls_installed"
  if [[ ! -f "${MARKER_NODE}" ]]; then
    (cd "${NODE_DIR}" && npm init -y >/dev/null 2>&1 || true)
    (cd "${NODE_DIR}" && npm install typescript typescript-language-server >/dev/null 2>&1)
    date > "${MARKER_NODE}"
  fi
  echo "export PATH=\"${NODE_DIR}/node_modules/.bin:\$PATH\"" >> "${CLAUDE_ENV_FILE}"
fi

exit 0
