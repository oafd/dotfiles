#!/bin/bash

# Convert a millisecond timestamp field to human-readable format
jqtime() {
  local field="$1"
  jq --arg field "$field" '
    . as $in
    | if $in[$field] then
        ($in[$field]
          | if type == "string" then tonumber else . end
          | . / 1000
          | strftime("%Y-%m-%d %H:%M:%S")
        ) as $converted
        | $in + {($field): $converted}
      else
        $in
      end
  '
}

fzf-search-paths() {
  local -a files
  local saved_buffer
  saved_buffer=$LBUFFER
  files=($(
    fzf --multi --ansi --border \
      --phony \
      --query "" \
      --prompt=" Text > " \
      --bind "change:reload:([[ -n {q} ]] && fd . --type f --hidden | xargs rg --files-with-matches --smart-case {q} || true)" \
      --preview-label="Matches in ${PWD}" \
      --preview='sh -c "
        query=\$1
        file=\$2
        [[ -f \$file && -n \$query ]] && batgrep --smart-case --color=always -C 2 \"\$query\" \"\$file\" " _ {q} {}' \
      --preview-window=right:55%:wrap
  ))

  if (( ${#files} > 0 )); then
    LBUFFER="${saved_buffer}${(j: :)files}"
  else
    LBUFFER="$saved_buffer"
  fi

  zle reset-prompt
}
zle -N fzf-search-paths
bindkey '^F' fzf-search-paths

jjos() {
  local is_array=false
  [[ "$1" == "-a" ]] && { is_array=true; shift; }

  local build_object() {
    local obj_args=("$@")
    jq -n  "$(for arg in "${obj_args[@]}"; do
      key="${arg%%=*}"
      val="${arg#*=}"

      # Type handling
      if [[ "$val" == "true" || "$val" == "false" || "$val" == "null" || "$val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        :
      else
        val="\"$val\""
      fi

      jq_path="$(echo "$key" | sed 's/\([^\.]*\)/"\1"/g' | sed 's/\./, /g')"
      printf 'setpath([%s]; %s) | ' "$jq_path" "$val"
    done | sed 's/ | $//')"
  }

  if $is_array; then
    local object=()
    local group=()
    for arg in "$@"; do
      if [[ "$arg" == "--" ]]; then
        object+=("$(build_object "${group[@]}")")
        group=()
      else
        group+=("$arg")
      fi
    done
    [[ "${#group[@]}" -gt 0 ]] && object+=("$(build_object "${group[@]}")")
    printf '[%s]\n' "$(IFS=,; echo "${object[*]}")"
  else
    build_object "$@"
  fi
}


jwt() {
  local token

# If argument is passed, use it
  if [[ -n "$1" ]]; then
    token="$1"
  # Else if something is piped into stdin, read it
  elif [[ -p /dev/stdin ]]; then
    token="$(cat)"
  # Else fallback to clipboard
  else
    token="$(pbpaste)"
  fi

  [[ -z "$token" ]] && { echo "No token provided" >&2; return 1 }

  local parts
  IFS='.' parts=(${(s:.:)token})
  local payload="${parts[2]}"

  local pad=$(( (4 - ${#payload} % 4) % 4 ))
  payload="${payload}$(printf '=%.0s' $(seq 1 $pad))"

  echo "$payload" | base64 -d 2>/dev/null | jq .
}

extract_app_version_changes() {
  awk '
    /^\-/ && $0 !~ /^\-\-\-/ {
      if (match($0, /[a-zA-Z0-9_-]+:[0-9]+\.[0-9]+\.[0-9]+/, m)) {
        key = m[0]
        split(key, a, ":")
        prev[a[1]] = a[2]
      }
    }
    /^\+/ && $0 !~ /^\+\+\+/ {
      if (match($0, /[a-zA-Z0-9_-]+:[0-9]+\.[0-9]+\.[0-9]+/, m)) {
        key = m[0]
        split(key, a, ":")
        name = a[1]
        curr = a[2]
        if ((name in prev) && !(name in printed)) {
          print name ": " prev[name] " -> " curr
          printed[name] = 1
        }
      }
    }
  '
}
envs() {
  env | cut -d= -f1 | fzf --preview 'printenv {}'
}

# Alt-e to fuzzy search env vars with preview
fzf-env-preview() {
  local selected saved_buffer
  saved_buffer=$LBUFFER  # Save the current line buffer

  selected=$(env | cut -d= -f1 | fzf --preview 'printenv {}')
  if [[ -n "$selected" ]]; then
    LBUFFER="${saved_buffer}${selected}="  # Restore and append
  else
    LBUFFER="$saved_buffer"  # Restore buffer if cancelled
  fi

  zle reset-prompt
}
zle -N fzf-env-preview
bindkey '^[e' fzf-env-preview

help() {
  "$@" --help 2>&1 | cat --paging=always --language=help
}
ksecret() {
  emulate -L zsh
  setopt pipefail

  local ns="kiwios" ctx="qa" filter="" name

  # Flags: -n/--namespace, --context, [optional substring filter]
  while (( $# )); do
    case "$1" in
      -n|--namespace) ns="$2"; shift 2 ;;
      --context)      ctx="$2"; shift 2 ;;
      *)              filter="$1"; shift ;;
    esac
  done

  # Pick a secret with fzf (Esc cleanly aborts)
  name="$(
    kubectl -n "$ns" --context "$ctx" get secret --no-headers 2>/dev/null \
      | awk '{print $1}' \
      | { [[ -n "$filter" ]] && grep -i -- "$filter" || cat; } \
      | fzf --prompt="Secret ($ns/$ctx)> " --height=15 --reverse \
            --preview "kubectl -n $ns --context $ctx get secret {} -o json \
                       | jq -r '.data | map_values(@base64d)'" \
            --preview-window=right:60%
  )" || return 130
  [[ -n $name ]] || return 130

  # Decode and emit all keys except 'ca.crt' and 'secret-old'
  local tsv
  tsv="$(
    kubectl -n "$ns" --context "$ctx" get secret "$name" -o json \
      | jq -r '.data
               | del(.["ca.crt"], .["secret-old"])
               | map_values(@base64d)
               | to_entries[]
               | "\(.key)\t\(.value)"'
  )" || { print -u2 "ksecret: failed to fetch/decode $name"; return 1; }

  # Export each key
  local exported=() key val
  while IFS=$'\t' read -r key val; do
    [[ -z $key ]] && continue
    typeset -g "$key"="$val"
    export "$key"
    exported+=("$key")
  done <<< "$tsv"

  if (( ${#exported[@]} == 0 )); then
    print -u2 "ksecret: no exportable fields in secret '$name' (after ignoring ca.crt and secret-old)"
    return 1
  fi

  print "Exported: ${exported[*]} from $name (ns=$ns ctx=$ctx)"
}
