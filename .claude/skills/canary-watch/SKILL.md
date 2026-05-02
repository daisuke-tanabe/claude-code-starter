---
name: canary-watch
description: デプロイ・マージ・依存アップグレード後のリグレッションを監視するために、デプロイ済み URL を監視するスキル。
---

# Canary Watch — デプロイ後監視

## 起動するタイミング

- 本番またはステージングへのデプロイ後
- リスクのある PR をマージした後
- 修正が実際に効いているかを確認したいとき
- ローンチウィンドウ中の継続監視
- 依存関係のアップグレード後

## 仕組み

デプロイ済み URL のリグレッションを監視する。停止されるか監視ウィンドウが切れるまでループで動作する。

### 監視対象

```
1. HTTP ステータス — ページは 200 を返しているか？
2. コンソールエラー — 以前は無かった新しいエラーはないか？
3. ネットワーク失敗 — 失敗した API 呼び出し、5xx 応答はないか？
4. パフォーマンス — ベースラインに対する LCP/CLS/INP のリグレッションはないか？
5. コンテンツ — 主要要素が消えていないか？(h1, nav, footer, CTA)
6. API ヘルス — クリティカルなエンドポイントは SLA 内で応答しているか？
```

### 監視モード

**Quick check**（デフォルト）: 単発実行して結果を報告
```
/canary-watch https://myapp.com
```

**Sustained watch**: N 分おきに M 時間チェックする
```
/canary-watch https://myapp.com --interval 5m --duration 2h
```

**Diff mode**: ステージングと本番を比較する
```
/canary-watch --compare https://staging.myapp.com https://myapp.com
```

### アラート閾値

```yaml
critical:  # 即時アラート
  - HTTP status != 200
  - 新規コンソールエラー数 > 5
  - LCP > 4s
  - API エンドポイントが 5xx を返す

warning:   # レポートにフラグ
  - LCP がベースラインから > 500ms 増加
  - CLS > 0.1
  - 新規コンソール警告
  - レスポンス時間がベースラインの 2 倍超

info:      # ログのみ
  - 軽微なパフォーマンス変動
  - 新規ネットワークリクエスト（サードパーティスクリプトが追加されたか？）
```

### 通知

クリティカル閾値を超えたとき:
- デスクトップ通知（macOS/Linux）
- 任意: Slack/Discord webhook
- プロジェクトルートの `./canary-watch.log` にログ出力

## 出力

```markdown
## Canary Report — myapp.com — 2026-03-23 03:15 PST

### ステータス: HEALTHY ✓

| チェック | 結果 | ベースライン | 差分 |
|-------|--------|----------|-------|
| HTTP | 200 ✓ | 200 | — |
| コンソールエラー | 0 ✓ | 0 | — |
| LCP | 1.8s ✓ | 1.6s | +200ms |
| CLS | 0.01 ✓ | 0.01 | — |
| API /health | 145ms ✓ | 120ms | +25ms |

### リグレッションは検出されなかった。デプロイはクリーン。
```

## 連携

組み合わせて使う:
- `/browser-qa` — デプロイ前検証
- Hooks: `git push` に対する PostToolUse hook として追加し、デプロイ後の自動チェックに使う
- CI: GitHub Actions のデプロイステップ後に実行する
