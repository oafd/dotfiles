#!/bin/bash

kpods() {
  local pod
  pod=$(kubectl get pods -n kiwios --no-headers -o custom-columns=":metadata.name" \
        | fzf --prompt="[kiwios] Pods > " --no-preview)

  if [[ -n "$pod" ]]; then
    LBUFFER+="$pod"
    zle reset-prompt
  fi
}

zle -N kpods
bindkey '^K' kpods

fzf-search-paths() {
  local -a files
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

  if [[ -n "$files" ]]; then
    LBUFFER+="${(j: :)files}"
    zle redisplay
  fi
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

extract_app_version() {
  grep '^+' \
    | grep -Ev '^\+\+\+' \
    | grep -Eo '[a-zA-Z0-9_-]+:[0-9]+\.[0-9]+\.[0-9]+'
}

# fuzzy search from current Dir
fzf_ctrl_g() {
  local file
  files=($(fd . --type f --type d --hidden --color=always \
        | sort \
        | fzf --prompt=' File > ' --multi --ansi \
        --bind shift-up:preview-page-up,shift-down:preview-page-down))

  # Insert the selected file path into the command line
  if [[ -n "$files" ]]; then
    LBUFFER+="${(j: :)files}"
    zle redisplay
  fi
}

# Bind to Ctrl-G
zle -N fzf_ctrl_g
bindkey '^G' fzf_ctrl_g


help() {
  "$@" --help 2>&1 | bat --paging=always --language=help
}
