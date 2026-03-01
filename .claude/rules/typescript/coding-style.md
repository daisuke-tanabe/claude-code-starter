---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript コーディングスタイル

TypeScript に特化したコーディングスタイル規約。

---

## 型注釈

関数の公開インターフェース（引数・返り値）には明示的な型注釈を付ける。

- `any` は使用禁止。型が不明な場合は `unknown` を使う
- `interface` はオブジェクト形状の定義に使う
- `type` は Union・Intersection・エイリアスに使う
- 推論できる箇所（変数の初期化値等）には型注釈を省略してよい

```typescript
// WRONG
function process(data: any) { ... }

// CORRECT
function process(data: unknown) { ... }
```

## イミュータビリティ

`readonly` 修飾子で変更を型レベルで禁止する。

```typescript
function process(items: readonly string[]) { ... }
```

## null/undefined の扱い

null/undefined への安全なアクセスを心がける。

## 型の絞り込み

`as` キャストを避け、型ガードで安全に型を絞り込む。

```typescript
// WRONG
const value = (response as SuccessResponse).data

// CORRECT
function isSuccess(res: Response): res is SuccessResponse {
  return res.status === 'success'
}
if (isSuccess(response)) { ... }
```

## エラーハンドリング

catch ブロックの `error` は `unknown` として扱い、型を確認してから使用する。

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  if (error instanceof Error) {
    console.error(error.message)
  }
  throw error
}
```

## 入力バリデーション

外部データはスキーマ定義でバリデーションルールを明示してから使用する。
ライブラリは問わないが、型安全な検証結果を返す形にする。

```typescript
// スキーマ検証の結果を型で表現する（ライブラリ非依存のパターン）
type ValidationResult<T> =
  | { success: true; data: T }
  | { success: false; error: string }

function validateUser(input: unknown): ValidationResult<User> { ... }
```
