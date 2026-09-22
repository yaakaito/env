# dig

dig は Matt Pocock の [grilling](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md) をベースにしたインタビュー用 Skill である。
[commit `85f83d3`](https://github.com/mattpocock/skills/blob/85f83d3fde1d3a90d5c9a657f6998c79a6c37308/skills/productivity/grilling/SKILL.md) の本文を基に、質問の依存関係、ラウンドごとの進行、事実調査、終了条件は原文に準拠している。

dig では、grilling の質問表示例を次の回答形式に置き換えている。

- 各ラウンドで質問できる項目が5問以下ならチャット、6問以上なら HTML 質問票を使う。ユーザーの形式指定を優先する。
- 選択肢に加えて自由記入を受け付け、進捗を表示する。推奨回答とユーザーの回答を区別する。
- HTML 質問票は未回答を含めて回答をコピーでき、クリップボードを使えない場合もテキストを選択できる。提供前に操作を確認する。

質問できる項目をすべて同じラウンドで提示し、回答後に次の質問を組み直す原則は変えない。

grilling の著作権表示と MIT ライセンス全文は [LICENSE](LICENSE) に収録している。
