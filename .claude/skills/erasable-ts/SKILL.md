---
name: erasable-ts
description: "TypeScript restrictions for Node.js native type stripping projects. Use when writing or reviewing TypeScript in a project that runs without tsx/ts-node (i.e., uses Node.js native type stripping), or when tsconfig has erasableSyntaxOnly: true."
version: 1.0.0
---

# Erasable TypeScript (Node.js native type stripping)

## 背景

Node.js v22.6+ はビルドステップなしで `.ts` を実行できる。
仕組みは「TypeScript 構文をホワイトスペースに置き換える(strip)」だけで、**コード生成は行わない**。

そのため、実行時 JS を生成しなければならない構文は使えない。
TypeScript 5.8 の `--erasableSyntaxOnly` フラグはこれをコンパイル時に強制する。

---

## 禁止構文と代替

### ❌ `enum`

```ts
// NG: ランタイムオブジェクトを生成するため strip 不可
enum Direction { Up = "UP", Down = "DOWN" }
```

```ts
// OK: 型のみ → strip 可能
const Direction = { Up: "UP", Down: "DOWN" } as const
type Direction = typeof Direction[keyof typeof Direction]
```

### ❌ Constructor parameter properties

```ts
// NG: this.name = name の代入をランタイムに生成するため strip 不可
class User {
  constructor(public name: string, private age: number) {}
}
```

```ts
// OK: 明示的なフィールド宣言 → strip 可能
class User {
  name: string
  private age: number
  constructor(name: string, age: number) {
    this.name = name
    this.age = age
  }
}
```

### ❌ `tsconfig paths` による import alias

```ts
// NG: Node.js は tsconfig.json を読まない
import { utils } from "@/utils"
```

```ts
// OK: 相対パス または workspace パッケージ参照
import { utils } from "../../utils.ts"
import { utils } from "@myapp/shared"
```

### ❌ `namespace` (値を含む場合)

```ts
// NG: モジュールオブジェクトを生成するため strip 不可
namespace Utils {
  export const VERSION = "1.0"
}
```

```ts
// OK: 通常の const export に分解する
export const VERSION = "1.0"
```

---

## その他の注意点

- `--experimental-transform-types` フラグを使えば enum 等も動くが、プロジェクト設定を優先すること
- 型のみの構文（`type`, `interface`, `as const`, `satisfies`, `readonly`, `abstract`）は strip 可能なので問題なし
- `import type` を積極的に使うことで strip 漏れリスクを下げられる
