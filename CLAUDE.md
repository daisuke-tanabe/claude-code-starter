# CLAUDE.md

## 機能実装ワークフロー

新機能・アーキテクチャ変更は OpenSpec の change として起こす：

- `/opsx:explore "<idea>"` — 発散・収束で思考を整理（任意）
- `/opsx:propose "<idea>"` — proposal / design / specs / tasks を一括生成
- `/opsx:apply` — tasks.md に従って実装（TDD は `tdd-workflow` skill）
- `/opsx:archive` — 完了 change を archive へ移し main specs を更新

## Git運用

- ブランチ戦略: GitHub Flow ベース、`main` を統合ブランチとする
- 作業ブランチは `main` から切り、PR 経由で `main` にマージ
- `main` への直接コミット禁止
- コミットメッセージ: Conventional Commits
- 詳細な git ベストプラクティスは `git-workflow` skill を参照
