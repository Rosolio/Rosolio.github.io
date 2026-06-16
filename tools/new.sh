#!/usr/bin/env bash
#
# Create a new post with front matter

help() {
  echo "Create a new Jekyll post"
  echo
  echo "Usage:"
  echo
  echo "   bash $0 \"文章标题\""
  echo
  echo "Example:"
  echo "   bash $0 \"我的第一篇博客\""
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  help
  exit 0
fi

TITLE="$1"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g; s/[^a-z0-9\-]//g')
FILENAME="_posts/${DATE}-${SLUG}.md"

cat > "$FILENAME" << EOF
---
title: ${TITLE}
date: ${DATE} ${TIME} +0800
categories: []
tags: []
---

EOF

git add "$FILENAME"
echo "Created: $FILENAME"