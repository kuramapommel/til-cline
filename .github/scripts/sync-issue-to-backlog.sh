#!/usr/bin/env bash
set -euo pipefail

# backlog フィールドが空の場合はスキップして正常終了
if [ -z "$BACKLOG_URL" ]; then
  echo "backlog フィールドが空のため、Notion への書き戻しをスキップします。"
  exit 0
fi

echo "バックログ URL: $BACKLOG_URL"

# Notion URL からページ ID を抽出する
# 対応形式:
#   https://www.notion.so/ページタイトル-<32文字のID>
#   https://www.notion.so/workspace/<32文字のID>
RAW_ID=$(echo "$BACKLOG_URL" | grep -oE '[0-9a-f]{32}' | tail -1)

if [ -z "$RAW_ID" ]; then
  echo "::error::Notion ページ ID を URL から抽出できませんでした: $BACKLOG_URL"
  exit 1
fi

# 32文字の16進数を UUID 形式（8-4-4-4-12）に変換する
PAGE_ID="${RAW_ID:0:8}-${RAW_ID:8:4}-${RAW_ID:12:4}-${RAW_ID:16:4}-${RAW_ID:20:12}"
echo "ページ ID: $PAGE_ID"

# Notion API で「関連 Issue」プロパティを更新する
curl --fail-with-body -s \
  -X PATCH "https://api.notion.com/v1/pages/${PAGE_ID}" \
  -H "Authorization: Bearer ${NOTION_API_TOKEN}" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  --data "{
    \"properties\": {
      \"関連 Issue\": {
        \"url\": \"${ISSUE_URL}\"
      }
    }
  }"

echo "Notion バックログの「関連 Issue」を更新しました: $ISSUE_URL"
