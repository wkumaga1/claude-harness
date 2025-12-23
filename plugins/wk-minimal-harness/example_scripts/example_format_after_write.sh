#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"

if ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

file_path="$(
  python3 - <<'PY'
import json, sys
data = json.loads(sys.stdin.read() or "{}")
tool_input = data.get("tool_input") or {}
print(tool_input.get("file_path",""))
PY
<<< "${payload}"
)"

[[ -z "${file_path}" ]] && exit 0
[[ ! -f "${file_path}" ]] && exit 0

# If JSON, normalize with python's json.tool
if [[ "${file_path}" == *.json ]]; then
  tmp="${file_path}.tmp.$$"
  python3 -m json.tool "${file_path}" > "${tmp}" 2>/dev/null && mv "${tmp}" "${file_path}" || rm -f "${tmp}"
  exit 0
fi

exit 0
