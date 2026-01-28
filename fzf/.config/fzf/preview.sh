#!/bin/bash

query=""
[[ $# -eq 2 ]] && query="$1"
file="$([[ $# -eq 2 ]] && echo "$2" || echo "$1")"

# Environment variable preview
if [[ -n "${!file+x}" ]]; then
  printf "%s" "${!file}"
  exit 0
fi

# Alias preview
if alias "$file" &>/dev/null; then
  echo "🔗 $(alias "$file")"
  exit 0
fi

# If file doesn't exist: print raw text
if [[ ! -e "$file" ]]; then
  echo -e "\n${file}" | fold -s -w "$(tput cols)"
  exit 0
fi

file="$(realpath "$file")"
mime=$(file -b --mime-type "$file")

case "$mime" in
application/pdf)
  pdftotext "$file" - 2>/dev/null | head -n 40
  ;;

image/*)
  if command -v exiftool &>/dev/null; then
    exiftool "$file"
  else
    echo "No EXIF tool available"
  fi
  ;;

text/markdown)
  mdcat "$file"
  ;;

application/zip | application/x-tar | application/x-7z-compressed | application/vnd.rar)
  ouch list -ty "$file"
  ;;

application/vnd.ms-excel | application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
  in2csv "$file" | head -n 40
  ;;

text/html)
  w3m -dump "$file"
  ;;

application/x-sqlite3)
  echo -e "\033[1;34m📦 SQLite DB: $(basename "$file")\033[0m"
  echo

  sqlite-utils tables "$file" --nl | head -n 3 | while read -r table; do
    echo -e "\n\033[1m📋 Table: $table\033[0m"

    sqlite-utils rows "$file" "$table" --limit 1 |
      jq -r '
            .[0] // {} | to_entries[] |
            if (.value|tostring|startswith("{") and (.value|fromjson?)) then
              "\(.key):", (.value|fromjson|to_entries[]| "  \(.key): \(.value)")
            else "\(.key): \(.value)" end
          ' |
      bat --language=yaml --style=plain --paging=never --color=always
  done
  ;;

*)
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
