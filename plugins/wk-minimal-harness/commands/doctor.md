# Doctor (sanity checks)

Run quick checks to confirm the harness is wired correctly.

Steps:
1) Print repo root: `pwd`
2) List expected files:
   - `.claude-plugin/marketplace.json`
   - `plugins/wk-minimal-harness/.claude-plugin/plugin.json`
   - `plugins/wk-minimal-harness/hooks/hooks.json`
   - `plugins/wk-minimal-harness/.mcp.json`
   - `plugins/wk-minimal-harness/.lsp.json`
3) Validate JSON:
   - `python3 -m json.tool .claude-plugin/marketplace.json >/dev/null`
   - `python3 -m json.tool plugins/wk-minimal-harness/.claude-plugin/plugin.json >/dev/null`
   - `python3 -m json.tool plugins/wk-minimal-harness/hooks/hooks.json >/dev/null`
   - `python3 -m json.tool plugins/wk-minimal-harness/.mcp.json >/dev/null`
   - `python3 -m json.tool plugins/wk-minimal-harness/.lsp.json >/dev/null`

Output:
- PASS/FAIL
- Missing files (if any)
- Notes on next steps
