# wk-minimal-harness

## Claude Code on the web (cloud) 注意
このプラグインは SessionStart で pip/npm を使う可能性があります。
クラウドで依存導入が必要な場合、ネットワーク制限の設定で以下のドメインを許可してください（必要に応じて）:
- pypi.org
- files.pythonhosted.org
- registry.npmjs.org

クラウドでネットワークが許可されていない場合、以下はスキップされる可能性があります:
- MCP stdio サーバの依存導入（mcp==1.7.1）
- LSP サーバの導入（python-lsp-server, typescript-language-server）

## 依存
- Python 3.x
- （任意）Node.js + npm（TypeScript LSP 用）

## Secrets
- .env はコミットしない
- 必要な環境変数は .env または .claude/settings.local.json に置く
