---
name: composing-workflows
description: "Use when reviewing or refactoring TypeScript/JavaScript service clients, handlers, or use cases where a higher-order helper accepts operation-specific callbacks and hides branching, early returns, logging, or result policies. Also use before extracting similar business workflows into a shared wrapper. Keep operation-specific control flow readable top-to-bottom while preserving abstractions that enforce shared invariants such as transactions, retries, authentication, locking, or observability."
---

# Composing Workflows（ワークフロー合成）

## 概要

公開関数は、**小さく名前の付いた単一責務のステップを上から下に並べた線形パイプライン**として読めるべき。
操作固有のオーケストレーション（制御フロー）を、クロージャを受け取る高階ラッパーの中に隠さない。

Domain Modeling Made Functional の "workflow" の考え方。Result 型ラッパーなどの道具立ては不要で、要点は「制御フローを見える場所に書く」こと。

**核となる原則: 操作固有の制御フローは各ワークフローに見える形で書く。共通の不変条件を担う抽象とは分離する。**

## When to Use（症状）

- ある関数が「データ + 処理の断片(クロージャ)」を高階ヘルパーに渡し、そのヘルパーが操作固有の分岐や返却ポリシーまで決めている
  （例: `callService({ method, orderId, success, call: () => ... })`）→ **制御反転**
- そのヘルパーを読まないと、公開関数が何をするのか追えない
- ジェネリクス制約の型が、その高階ヘルパーに食わせるためだけに存在する
  （例: 全操作の結果を寄せ集めた `AnyResult` union）
- 「near-identical な操作が N 個あるから DRY にしたい」という理由だけで、操作固有の分岐や返却ポリシーまで共有ラッパーへ移そうとしている
- 公開関数を上から下に読んでも、何がどの順で起きるか分からない

## The Smell: 高階ラッパーへの制御反転

```typescript
// ❌ 制御が反転している。reserve を読んでも何が起きるか分からず、
//    callService の本体と call: クロージャを同時に脳内展開する必要がある。
async function callService<T extends AnyResult>(p: {
  method: string; orderId: number; skuIds: string[]; success: T;
  call: () => Promise<{ result: T; httpStatus: number | null }>;
}): Promise<T> {
  const mode = await getMode(p.skuIds);
  if (mode === "off") return p.success;          // 早期 return が呼び出し元から見えない
  const out = await p.call();                      // 計測・ログ・返却ポリシーも全部ここ
  log({ method: p.method, result: out.result.type, httpStatus: out.httpStatus });
  return mode === "on" ? out.result : p.success;
}

export const reserve = (orderId, items) => {
  const skuIds = items.map((item) => item.skuId);
  return callService({ method: "Reserve", orderId, skuIds, success: { type: "reserved" },
    call: () => requestReserve(orderId, items) }); // ← 操作固有の処理を断片として渡している
};
```

```typescript
// ✅ ワークフロー。reserve を上から下に読めば全部見える。
//    各ステップは1責務の名前付き関数。
const resolveMode = (skuIds: string[]) => { /* フラグ → "off"|"dryRun"|"on" */ };
const requestReserve = (orderId, items) => { /* HTTP を撃ち、ドメイン結果に解釈。計測込み */ };

export const reserve = async (orderId, items): Promise<ReserveResult> => {
  const skuIds = items.map((i) => i.skuId);

  const mode = await resolveMode(skuIds);
  if (mode === "off") return { type: "reserved" };          // 短絡が見える

  const { result, httpStatus, durationMs } = await requestReserve(orderId, items);

  log({ method: "Reserve", mode, skuIds, result: result.type,
        reason: result.type === "rejected" ? result.reason : null, httpStatus, durationMs });

  return mode === "on" ? result : { type: "reserved" };      // 返却ポリシーが見える
};
```

## The Move

1. **オーケストレーションの各ステップを1責務の名前付き関数に切り出す**（`resolveMode` / `requestReserve` / `log` …）。
   transport（HTTP・認証）やログ整形のような純粋に共有されるロジックは、関数に切り出してよい（むしろ切り出すべき）。
2. **公開関数の中で、それらを上から下に並べて合成する。** 早期 return・計測・ログ・分岐・返却ポリシーを、すべて見える場所に置く。
3. **操作固有の business workflow は素直に書く。** 複数の workflow が似ていても、分岐・早期 return・返却ポリシーが異なるなら、それらを共有の高階ラッパーに隠さない。

## DRY ではなく DAMP（最重要の反証）

「似た構造 = 重複排除すべき」ではない。
**読みやすい数行のパイプラインを N 関数で繰り返す方が、脳内で展開しないと読めない高階ラッパー1つより良い。**

- 重複させてよい: 操作固有のオーケストレーション（ステップの並び）。各 workflow が自己完結で読めることの価値が勝る。
- 重複させない: 1責務のステップ（transport, token取得, ログ整形）や、全操作で同一であるべき不変条件。これは関数や専用の抽象へ切り出す。

## When NOT to Apply

- **ヘルパー関数そのものを禁止する skill ではない。** 1責務の共有ロジック（HTTP transport / トークン取得 / ログ出力）は関数に切り出すのが正しい。
- 高階関数が悪いのではなく、「**制御フローを隠す**高階ラッパー」が悪い。`map`/`filter` や、フレームワーク要件としての本物のミドルウェアチェーンは対象外。
- トランザクション、リトライ、認証、排他制御、計測など、**全操作で同一であるべき不変条件を一元的に保証するラッパー**は対象外。そのラッパーには操作固有の分岐や返却ポリシーを混在させない。
- ステップが1〜2個で分岐も無い極小関数は、そのまま書けばよい。

## Common Mistakes

| やりがちな対応 | なぜダメか |
| --- | --- |
| 高階ラッパーをリネームして「整理した」と思う（`callService`→`withFlagGate` 等） | 制御反転は残ったまま。名前は変わっても読めなさは同じ |
| DRY 圧力だけで**さらに高階関数を足す**（`safeFetch` 等） | 操作固有の制御まで移すと、層が増えて読めなさが悪化する |
| ジェネリクス制約や `as` キャストで型の辻褄を合わせる | ステップを具体型で書けば制約もキャストも消える |
| transport まで各 workflow にインライン展開する | それは1責務の共有ステップ。関数のまま呼ぶ |

## Red Flags — 止まって考える

- ヘルパーが `call: () => ...` のような**処理のクロージャ**を受け取り、その前後で操作固有の分岐や返却ポリシーを決めている
- 公開関数の本体が「ヘルパーを1回呼ぶだけ」になっている
- 型 union が「ログや分岐で `.type` を触るための制約」としてだけ存在する
- レビューコメント「DRY にして」に対して、不変条件ではなく操作固有の制御まで共有抽象へ移そうとしている

これらは「操作固有のワークフローを線形に書き直し、共有は1責務のステップまたは共通の不変条件に限る」ことを検討するサイン。
