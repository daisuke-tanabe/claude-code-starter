# 開発ワークフロー

> git運用の前提は CLAUDE.md の「Git運用」セクションを参照。詳細な git パターンは `git-workflow` skill を参照。

機能実装ワークフローは開発パイプライン（リサーチ、計画、TDD、コードレビュー、そしてgitへのコミット）を説明する。

## 機能実装ワークフロー

0. **リサーチ & 再利用** _（新しい実装の前に必須）_
   - **GitHub検索を最初に：** 新しいものを書く前に `gh search repos` と `gh search code` を実行して既存の実装、テンプレート、パターンを探す。
   - **ライブラリドキュメントを2番目に：** 実装前にContext7またはプライマリベンダードキュメントを使用してAPI動作、パッケージ使用法、バージョン固有の詳細を確認する。
   - **Exaは最初の2つが不十分な場合のみ：** GitHubとプライマリドキュメントで不十分な場合にのみ、より広いウェブリサーチや発見のためにExaを使用する。
   - **パッケージレジストリを確認：** ユーティリティコードを書く前にnpm、PyPI、crates.ioなどのレジストリを検索する。手作りのソリューションより実績あるライブラリを優先する。
   - **適応可能な実装を探す：** 問題の80%以上を解決できるオープンソースプロジェクトを探してフォーク、移植、またはラップする。
   - 要件を満たす場合は、新規コード作成より実績あるアプローチの採用や移植を優先する。

1. **まず計画する**
   - 発散・収束が必要なら先に `/opsx:explore` で思考を整理する
   - `/opsx:propose "<内容>"` で OpenSpec の change を起こす
   - 生成される成果物：`proposal.md`（why）、`design.md`（how）、`specs/`、`tasks.md`
   - 依存関係とリスクは proposal.md / design.md に書き出す
   - フェーズは tasks.md のチェックリストに分解する
   - design.md は **architect** エージェントでレビューする（トレードオフ、ADR、アンチパターン）

2. **実装（TDD アプローチ）**
   - `/opsx:apply` で tasks.md に従って実装を進める
   - 各タスクで **tdd-guide** エージェントを呼ぶ：RED → GREEN → IMPROVE
   - 詳細手順は `tdd-workflow` skill を参照
   - 80%以上のカバレッジを確認する

3. **コードレビュー**
   - コード記述直後に **code-reviewer** エージェントを使用する
   - CRITICALとHIGHの問題に対処する
   - 可能な場合はMEDIUMの問題も修正する

4. **アーカイブ & コミット**
   - 全タスク完了後に `/opsx:archive` で change を archive へ移し、main specs を更新
   - Conventional Commits フォーマットに従う
   - 詳細な git ベストプラクティスは `git-workflow` skill を参照

## 規範 skill の参照タイミング

OpenSpec のフェーズごとに参照すべき skill：

| フェーズ | 参照すべき skill |
|---|---|
| `/opsx:explore` / `/opsx:propose`（design.md 起稿） | `hexagonal-architecture` / `backend-patterns` / `frontend-patterns` / `api-design` / `database-migrations` |
| `/opsx:apply`（実装中） | `coding-standards` / `tdd-workflow` / ドメイン別 skills（`postgres-patterns` 等） |
| 実装後レビュー | `security-review` / `accessibility` / `seo`（該当時） |
| デプロイ前 | `deployment-patterns` / `e2e-testing` / `browser-qa` |

design.md に「参照する skill」セクションを設けて、どの規範に従うかを明示すると後続の apply 工程が安定する。