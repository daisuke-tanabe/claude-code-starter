---
name: browser-qa
description: 機能のデプロイ後、ブラウザ自動化を用いて視覚テストと UI インタラクション検証を自動化するスキル。
---

# Browser QA — 自動視覚テスト & インタラクション検証

## 起動するタイミング

- ステージング/プレビューに機能をデプロイした後
- 複数ページにわたる UI 挙動を検証する必要がある場合
- 出荷前 — レイアウト、フォーム、インタラクションが実際に動作することを確認する
- フロントエンドコードを変更した PR をレビューする際
- アクセシビリティ監査やレスポンシブテスト

## 仕組み

ブラウザ自動化 MCP（claude-in-chrome、Playwright、Puppeteer）を使い、実ユーザーのようにライブページを操作する。

### Phase 1: Smoke Test
```
1. 対象 URL にナビゲートする
2. コンソールエラーをチェックする（ノイズ除外: analytics、サードパーティ）
3. ネットワークリクエストに 4xx/5xx が無いことを確認する
4. デスクトップ + モバイルビューポートで above-the-fold をスクリーンショット
5. Core Web Vitals を確認: LCP < 2.5s、CLS < 0.1、INP < 200ms
```

### Phase 2: Interaction Test
```
1. 全 nav リンクをクリック — 死リンクが無いことを確認
2. 正しいデータでフォーム送信 — 成功状態を確認
3. 不正なデータでフォーム送信 — エラー状態を確認
4. auth フローのテスト: login → 保護ページ → logout
5. クリティカルなユーザージャーニーをテスト（checkout、オンボーディング、検索）
```

### Phase 3: Visual Regression
```
1. 主要ページを 3 つのブレークポイント（375px、768px、1440px）でスクリーンショット
2. ベースラインスクリーンショット（保存されていれば）と比較
3. 5px 超のレイアウトシフト、要素の欠落、はみ出しをフラグ
4. ダークモード対応の場合は確認
```

### Phase 4: Accessibility
```
1. 各ページで axe-core などを実行
2. WCAG AA 違反をフラグ（コントラスト、ラベル、フォーカス順）
3. キーボードナビゲーションがエンドツーエンドで動作することを確認
4. スクリーンリーダーの landmarks を確認
```

## 出力フォーマット

```markdown
## QA Report — [URL] — [timestamp]

### Smoke Test
- コンソールエラー: 0 critical、2 warnings（analytics ノイズ）
- ネットワーク: 全て 200/304、失敗なし
- Core Web Vitals: LCP 1.2s ✓、CLS 0.02 ✓、INP 89ms ✓

### インタラクション
- [✓] nav リンク: 12/12 動作
- [✗] お問い合わせフォーム: 不正なメールに対するエラー状態が無い
- [✓] auth フロー: login/logout 動作

### ビジュアル
- [✗] 375px ビューポートで hero セクションがはみ出している
- [✓] ダークモード: 全ページで一貫

### アクセシビリティ
- AA 違反 2 件: hero 画像に alt テキストなし、フッターリンクのコントラスト不足

### 判定: SHIP WITH FIXES（issues 2 件、blockers 0 件）
```

## 統合

任意のブラウザ MCP と連携する:
- `mcp__claude-in-chrome__*` ツール（推奨 — 実際の Chrome を利用）
- `mcp__browserbase__*` 経由の Playwright
- 直接的な Puppeteer スクリプト

デプロイ後監視は `/canary-watch` と組み合わせる。
