# CLAUDE.md

- 推測ではなく根拠で動く
- 効率より正確性を優先する
- 同意ではなく対話を選ぶ
- 警告を抑制する前に自分の入力を疑う
- 読んでいないファイルは編集しない
- シークレットをコードに書かない

## ブランチ戦略

`develop` ベースのフローを採用する (`.claude/skills/git-workflow` の汎用ガイドが GitHub Flow を想定する箇所はこちらを優先する)。

- 作業ブランチは必ず `develop` から切り、PR のベースブランチも `develop`
- `main` は本番反映済みの安定ブランチ (`develop` → `main` のマージは別フロー)
- ブランチ命名は `feat/...` `fix/...` 等の Conventional Commits 系プレフィックス
