# UX ストーリーボードの考え方と表現指針

成果物 HTML の (B) UX ストーリーボード部の作り方。**見た目崩れ（枠外はみ出し・要素重なり・コマ間不揃い）は絶対に避ける**。

## UX ストーリーボードとは

製品・サービスを利用したユーザーの**理想体験**を、4 コマ漫画や絵コンテのような連続するシーンで表現する手法。文字だけのフロー説明より、**感情の流れと文脈**が伝わりやすい。

## 表現の自由度（構成）

**構成はテンプレ化しない**。導出した Products and Services のイメージに合わせて、毎回自由に選ぶ。

- 4 コマ（起承転結 4 シーン）
- 絵コンテ（5 〜 8 コマで体験のヤマを描く）
- ビフォー / アフター 2 コマ（変化の対比を強調する場合）
- タイムライン横長型（時間軸に沿って体験の流れを描く）
- 状態遷移型（感情グラフ＋シーン）

「どれが正解」はない。**そのペルソナと製品・サービスにとって最も体験が伝わる形**を選ぶ。

## SVG レイアウトの厳守ルール（重要）

構成は自由でも、SVG レイアウトの寸法・座標には**必ず次のグリッドを守る**。目分量で描かない。

### グリッド設計

**キャンバス全体（コマ数で選ぶ）:**

| 構成 | 全体サイズ | コマサイズ | コマ間隔 (gutter) | 左右余白 |
|---|---|---|---|---|
| 2 コマ | 720 × 260 | 320 × 220 | 40 | 20 |
| 4 コマ | 1200 × 300 | 260 × 240 | 20 | 20 |
| 5 コマ | 1200 × 260 | 220 × 220 | 15 | 15 |
| 6 コマ | 1200 × 240 | 180 × 200 | 12 | 12 |
| 8 コマ | 1200 × 220 | 135 × 180 | 10 | 10 |

**キャンバス上部にキャプション帯を置く場合は、コマ高さ + 40px を全体高さに加算**（キャプションは各コマ下 32px の帯に描く）。

### 座標計算のルール

各コマの `<rect>` の左端 x 座標は：

```
x_i = margin_left + i * (panel_width + gutter)  （i = 0, 1, 2, ...）
```

四則演算で機械的に決める。**「だいたい」で座標を置かない**。

### 内側マージン（安全領域）

- コマの枠 (`<rect>`) から内側 **10px** の領域を「安全領域」とし、**すべてのテキスト・図形はこの中に収める**。
- 顔・オブジェクトの中心座標は、コマの中心から縦方向 -20 〜 +10 の範囲に置く（キャプション帯と重ならないため）。

### テキスト折返しの禁止

SVG の `<text>` は自動折り返ししない。**1 行に収まる文字数**を厳守:

| コマ幅 | キャプション最大文字数 | 吹き出し最大文字数 |
|---|---|---|
| 320px | 20 文字 | 12 文字 |
| 260px | 16 文字 | 10 文字 |
| 220px | 13 文字 | 8 文字 |
| 180px | 11 文字 | 7 文字 |
| 135px | 8 文字 | 5 文字 |

日本語のフォント幅を **12px（キャプション）/ 11px（吹き出し）** 基準で計算した目安。**上限超えは 2 行に分ける**（`<tspan x="..." dy="1.2em">` で改行）。

### 文字の中央揃え

`text-anchor="middle"` を使い、コマの中心 x に揃える。**目分量で x を決めない**。

```
caption_x = x_i + panel_width / 2
caption_y = y_bottom_of_panel - 10   （安全領域下端）
```

### フォントサイズ

- キャプション: 12px（コマ 220px 以上）／ 11px（コマ 180px 以下）
- 吹き出し内: 11px（コマ 220px 以上）／ 10px（コマ 180px 以下）
- **これ以下には小さくしない**。読めなくなる。

### SVG 属性の必須設定

```xml
<svg
  width="1200" height="300"
  viewBox="0 0 1200 300"
  xmlns="http://www.w3.org/2000/svg"
  preserveAspectRatio="xMidYMid meet"
  font-family="'Hiragino Sans','Noto Sans JP',sans-serif">
```

- `viewBox` を必ず指定（後段の縮小時に崩れない）。
- `preserveAspectRatio` は `xMidYMid meet`（アスペクト維持・中央揃え）。
- ルート `<svg>` に `font-family` を入れて全 `<text>` に継承させる。

## 各シーンの構成要素

- **人物**: 顔は単純化（円＋目＋口の線）。表情でストーリーを語る（困り顔・驚き顔・笑顔）。
- **環境**: 1 〜 3 個のオブジェクトで場所を示唆（PC、机、椅子、窓、スマホ、ベッド）。
- **吹き出し / 内心**: 感情やセリフを端的に。長文にしない。
- **キャプション**: コマ下にシーンを 1 行で説明。

## 構成のコツ

- **起点となる Pain を最初のコマに置く**: 現状の困りごと・嫌な瞬間。
- **製品・サービスとの出会い**を 2 コマ目に。
- **使ってみたときの体験**を中盤に。
- **得られた Gain（情緒的な変化を含む）**を最後のコマに。

## 4 コマ SVG テンプレート（参考実装）

以下は 4 コマ構成での「そのまま流用してよい」骨格。**変数だけ差し替える**運用にすると崩れない。

```xml
<svg width="1200" height="300" viewBox="0 0 1200 300"
     xmlns="http://www.w3.org/2000/svg"
     preserveAspectRatio="xMidYMid meet"
     font-family="'Hiragino Sans','Noto Sans JP',sans-serif">

  <!-- 背景 -->
  <rect width="1200" height="300" fill="#faf8f3"/>

  <!-- コマ 1: x=20, y=20, w=260, h=240 -->
  <g transform="translate(20,20)">
    <rect width="260" height="240" fill="#ffffff" stroke="#d8d4ca" stroke-width="1" rx="8"/>
    <!-- 顔（コマ中心近く、y は安全領域内） -->
    <circle cx="130" cy="100" r="34" fill="#f4e6d0" stroke="#4b5160" stroke-width="1.5"/>
    <circle cx="118" cy="94" r="2.5" fill="#2a2e3a"/>
    <circle cx="142" cy="94" r="2.5" fill="#2a2e3a"/>
    <!-- 困り顔（下向きカーブ） -->
    <path d="M118 116 Q130 108 142 116" stroke="#2a2e3a" stroke-width="1.6" fill="none" stroke-linecap="round"/>
    <!-- 環境（PC） -->
    <rect x="70" y="150" width="120" height="60" fill="#e6f0f2" stroke="#4b5160" stroke-width="1" rx="4"/>
    <rect x="90" y="210" width="80" height="6" fill="#4b5160" rx="2"/>
    <!-- キャプション（安全領域内、text-anchor middle） -->
    <text x="130" y="230" text-anchor="middle" font-size="12" fill="#2a2e3a">
      集中したい朝、通知の波
    </text>
  </g>

  <!-- コマ 2: x=300, y=20 -->
  <g transform="translate(300,20)">
    <rect width="260" height="240" fill="#ffffff" stroke="#d8d4ca" stroke-width="1" rx="8"/>
    <!-- 顔（安堵） -->
    <circle cx="130" cy="100" r="34" fill="#f4e6d0" stroke="#4b5160" stroke-width="1.5"/>
    <circle cx="118" cy="94" r="2.5" fill="#2a2e3a"/>
    <circle cx="142" cy="94" r="2.5" fill="#2a2e3a"/>
    <path d="M118 112 Q130 118 142 112" stroke="#2a2e3a" stroke-width="1.6" fill="none" stroke-linecap="round"/>
    <text x="130" y="230" text-anchor="middle" font-size="12" fill="#2a2e3a">
      集中モードを起動
    </text>
  </g>

  <!-- コマ 3: x=580, y=20 -->
  <g transform="translate(580,20)">
    <rect width="260" height="240" fill="#ffffff" stroke="#d8d4ca" stroke-width="1" rx="8"/>
    <!-- 顔（真剣・笑み） -->
    <circle cx="130" cy="100" r="34" fill="#f4e6d0" stroke="#4b5160" stroke-width="1.5"/>
    <circle cx="118" cy="94" r="2.5" fill="#2a2e3a"/>
    <circle cx="142" cy="94" r="2.5" fill="#2a2e3a"/>
    <path d="M118 114 Q130 122 142 114" stroke="#2a2e3a" stroke-width="1.6" fill="none" stroke-linecap="round"/>
    <text x="130" y="230" text-anchor="middle" font-size="12" fill="#2a2e3a">
      90 分の集中実装
    </text>
  </g>

  <!-- コマ 4: x=860, y=20 -->
  <g transform="translate(860,20)">
    <rect width="260" height="240" fill="#ffffff" stroke="#d8d4ca" stroke-width="1" rx="8"/>
    <!-- 顔（満足） -->
    <circle cx="130" cy="100" r="34" fill="#f4e6d0" stroke="#4b5160" stroke-width="1.5"/>
    <circle cx="118" cy="94" r="2.5" fill="#2a2e3a"/>
    <circle cx="142" cy="94" r="2.5" fill="#2a2e3a"/>
    <path d="M118 114 Q130 124 142 114" stroke="#2a2e3a" stroke-width="1.6" fill="none" stroke-linecap="round"/>
    <text x="130" y="230" text-anchor="middle" font-size="12" fill="#2a2e3a">
      定時で終わる夜
    </text>
  </g>
</svg>
```

## レイアウト精度チェックリスト（出力前に必ず走らせる）

HTML 出力前、以下をすべて満たしていることを確認する。**1 つでも NG があれば作り直す**。

- [ ] `<svg>` の `viewBox` が全体サイズと一致している
- [ ] すべての `<rect>`（コマ枠）が `viewBox` 内に収まっている
- [ ] すべての `<text>` が対応するコマの**安全領域内**（枠内側 10px）に収まっている
- [ ] `<text>` の文字数がコマ幅の上限を超えていない（超える場合 `<tspan>` で改行）
- [ ] コマ間の gutter が等間隔（左端 x 座標を計算式で確認）
- [ ] `text-anchor="middle"` を使うテキストは x 座標がコマの中心に一致している
- [ ] キャプション帯とオブジェクトが重なっていない
- [ ] フォントサイズが最低値（10px）を下回っていない
- [ ] 顔の目・口の座標が顔輪郭の中心に対して対称になっている

## デバッグ tips

- 出力前に、コマ枠だけを描いた状態で座標が正しいかを確認する（テキスト・オブジェクトなしで骨格を先に固める）。
- 文字がはみ出す場合、まず**文字数を減らす**。フォントを小さくして詰め込まない。
- ペルソナ像に合わせた配色は 2 〜 3 色に絞る（背景色 + アクセント 1 色 + テキスト色）。

## ストーリーボードを描くタイミング

ステップ 7 の HTML 生成時。Products and Services が確定し、Fit 点検が済んだ後に描く。

ストーリーボードを描いたとき、エージェントが「この体験は本当にこのペルソナに刺さっているか?」を最終チェックすることになるので、**Fit 点検の自然な確認役にもなる**。違和感があれば、HTML 出力前にユーザーに気づきとして返してよい。
