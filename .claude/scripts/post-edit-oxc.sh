#!/usr/bin/env bash
# =============================================================================
# post-edit-oxc.sh
# =============================================================================
# 【役割】
#   Claude Code の PostToolUse フックとして動作する。
#   Write / Edit / MultiEdit ツール実行後に自動で oxfmt フォーマットと
#   oxlint チェックを走らせる。
#
# 【呼ばれるタイミング】
#   Claude が .ts/.tsx/.js/.jsx ファイルを編集するたびに自動実行される。
#
# 【入力】
#   stdin に Claude が渡す JSON が流れてくる。
#   jq で tool_input.file_path または tool_input.path を取り出してファイルパスを得る。
#
# 【スキップ条件】
#   - 対象ファイルが .ts/.tsx/.js/.jsx 以外
#   - node_modules/.bin/oxlint が存在しない
# =============================================================================
set -euo pipefail

file="$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<< "$(cat)")"

case "$file" in
  *.ts|*.tsx|*.js|*.jsx) ;;
  *) exit 0 ;;
esac

[ -f "node_modules/.bin/oxlint" ] || exit 0

# oxfmt でフォーマット
if [ -f "node_modules/.bin/oxfmt" ]; then
  node_modules/.bin/oxfmt "$file" 2>/dev/null || true
fi

# oxlint でチェック
diag="$(node_modules/.bin/oxlint "$file" 2>&1 | head -20)" || true

if [ -n "$diag" ]; then
  jq -Rn --arg msg "$diag" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: $msg
    }
  }'
fi