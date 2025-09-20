#!/bin/bash

# Handle one or two parameters
if [[ $# -eq 2 ]]; then
  query="$1"
  file="$2"
else
  query=""
  file="$1"
fi

# Check if input is an environment variable name
if printenv "$file" &>/dev/null; then
  echo "🌍 Environment variable: $file"
  echo ""
  printenv "$file"
  exit 0

fi
# check for Alias
if alias "$file" &>/dev/null; then
  echo "🔗 $(alias "$file")"
  exit 0
fi

# If input doesn't exist as a file or directory, just print it (e.g. from history)
if [[ ! -e "$file" ]]; then
  echo ""
  echo "$file" | fold -s -w "$(tput cols)"
  exit 0
fi

file="$(realpath "$file")"

case "$file" in
*.pdf)
  pdftotext "$file" - | head -n 40
  ;;
*.png | *.jpg | *.jpeg | *.gif)
  exiftool "$file"
  ;;
*.ico)
  magick "$file" PNG:- | chafa -
  ;;
*.md)
  mdcat "$file"
  ;;
*.zip | *.jar | *.tar | *.tar.gz | *.bz2 | *.tar.bz2 | *.7z | *.rar)
  ouch list -ty "$file"
  ;;
*.xls | *.xlsx)
  in2csv "$file" | head -n 40
  ;;
*.html)
  lynx -dump "$file"
  ;;
*.db)
  echo -e "\033[1;34m📦 SQLite DB: $(basename "$file")\033[0m"
  echo

  tables=$(sqlite-utils tables "$file" | jq -r '.[].table' | head -n 3)

  for table in $tables; do
    echo -e "\n\033[1m📋 Table: $table\033[0m"

    sqlite-utils rows "$file" "$table" --limit 1 | jq -r '
        .[0] |  select(. != null) | to_entries[] |
        if .key == "value" and (.value | test("^{.*}$")) then
          "\(.key):", 
          (.value | fromjson | to_entries[] | "  \(.key): \(.value)")
        else
          "\(.key): \(.value)"
        end
      ' | bat --language yaml --style=plain --paging=never --color=always
  done
  ;;
*/*)
  if [[ -f "$file" && -n "$query" ]]; then
    batgrep --smart-case --color=always -C 2 "$query" "$file"
  elif [[ -d "$file" ]]; then
    eza --tree --git --git-ignore --icons --color=always "$file"
  elif grep -Iq . "$file"; then
    bat --style=header,numbers --color=always --paging=never "$file"
  else
    echo "Not a text file — preview skipped"
  fi
  ;;
esac
