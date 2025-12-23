# Claude Code Plugins - Minimal Harness Marketplace

A minimal Claude Code marketplace containing one reference plugin (`wk-minimal-harness`) that demonstrates:

- **Hooks** (SessionStart, PostToolUse)
- **MCP (stdio)** server integration
- **LSP** (Python and TypeScript) integration
- **Commands**, **Agents**, and **Skills**

## Structure

```
.claude-plugin/
└── marketplace.json          # Marketplace definition

plugins/wk-minimal-harness/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── CLAUDE.md                 # Plugin-level instructions for Claude
├── commands/
│   ├── doctor.md             # Sanity check command
│   └── review.md             # Code review command
├── agents/
│   └── code-reviewer.md      # Code review agent
├── skills/
│   └── repo-conventions/
│       └── SKILL.md          # Repo conventions skill
├── hooks/
│   └── hooks.json            # Hooks configuration
├── example_scripts/          # Example hook/MCP/LSP scripts
│   ├── example_sessionstart_env.sh
│   ├── example_format_after_write.sh
│   ├── example_mcp_venv_setup.sh
│   ├── example_run_mcp_server.sh
│   └── example_lsp_bootstrap.sh
├── example_python/
│   └── requirements.txt      # MCP server dependencies
├── example_mcp_servers/
│   └── example_mcp_server.py # Example MCP server (stdio)
├── .mcp.json                 # MCP server configuration
└── .lsp.json                 # LSP server configuration
```

## Installation

Add this marketplace to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "wkumaga1-claude-harness": {
      "source": { "source": "github", "repo": "wkumaga1/claude-harness" }
    }
  },
  "enabledPlugins": [
    "wk-minimal-harness@wkumaga1-claude-harness"
  ],
  "env": {
    "MCP_TIMEOUT": "120000",
    "MCP_TOOL_TIMEOUT": "600000"
  }
}
```

## Claude Code on the Web (Cloud) Notes

When using Claude Code in cloud environments, network restrictions may apply.

### Required Domain Allowlist

If your cloud environment restricts network access, allow these domains:

- `pypi.org` - Python package index
- `files.pythonhosted.org` - Python package downloads
- `registry.npmjs.org` - npm package registry

### Behavior in Restricted Environments

When `CLAUDE_CODE_REMOTE=true` and network is restricted:

- MCP venv setup will skip (safe early exit)
- LSP bootstrap will skip (safe early exit)
- The plugin will still function for commands/agents/skills

## Verification

After installation, run the `doctor` command to verify the setup:

1. Check expected files exist
2. Validate all JSON files:
   ```bash
   python3 -m json.tool .claude-plugin/marketplace.json
   python3 -m json.tool plugins/wk-minimal-harness/.claude-plugin/plugin.json
   python3 -m json.tool plugins/wk-minimal-harness/hooks/hooks.json
   python3 -m json.tool plugins/wk-minimal-harness/.mcp.json
   python3 -m json.tool plugins/wk-minimal-harness/.lsp.json
   ```

### MCP Verification (Local)

After SessionStart runs:
1. The MCP venv should be created at `.claude/runtime/mcp/wk-example-stdio/venv/`
2. MCP tools (`add`, `echo`) should be available

### LSP Verification (Local)

After SessionStart runs:
1. `pylsp` should be on PATH (from `.claude/runtime/lsp/py-venv/bin/`)
2. Python files should have symbol navigation support

## Environment Variables

- `CLAUDE_CODE_REMOTE` - Set to `true` in cloud environments
- `CLAUDE_PLUGIN_ROOT` - Path to the plugin directory (set by Claude Code)
- `CLAUDE_PROJECT_DIR` - Path to the project directory (set by Claude Code)
- `CLAUDE_ENV_FILE` - Path to the env file for SessionStart hooks (set by Claude Code)

## Secrets

Do not commit `.env` files. Use `.env.example` as a template:

```bash
cp .env.example .env
# Edit .env with your secrets
```

## License

MIT
