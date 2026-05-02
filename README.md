# claude-code-starter

Claude Code の設定をまとめたスターターテンプレート。

## ベースとした参考リポジトリ

本プロジェクトの Claude Code 設定（`.claude/` 配下の agents / commands / skills / rules）は、[everything-claude-code](https://github.com/affaan-m/everything-claude-code) を参考にして、以下の方針で取捨選択・カスタマイズしている：

- **言語スタック**: TypeScript にフォーカス
- **不要なドメイン特化スキル**を削除（営業・マーケ・金融・物流・ヘルスケア等）
- **未使用言語のスキル**を削除（Python・Go・Rust・Kotlin・Swift・Java・C++ 等）
- 全ての agents / commands / skills を **日本語に編訳**
- 一部スキル / コマンドはこのプロジェクト用に追記・調整

## ライセンス

MIT — [LICENSE](./LICENSE) を参照。
