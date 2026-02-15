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

  [[ -z "$token" ]] && { echo "No token provided" >&2; return 1; }

  local payload
  payload=$(echo "$token" | cut -d. -f2)

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

j() {
  local ver="$1"
  local home
  home="$(/usr/libexec/java_home -v "$ver" 2>/dev/null)" || return 1

  export JAVA_HOME="$home"
  export PATH="$JAVA_HOME/bin:${PATH//:$JAVA_HOME\/bin/}"  # cheap dedupe-ish
  hash -r
  java -version
}

j8(){  j 1.8; }
j11(){ j 11; }
j17(){ j 17; }
j21(){ j 21; }
j22(){ j 22; }
j25(){ j 25; }

_kmysql_usage() {
  cat <<EOF
Usage: kmysql [options] [secret_filter]

Connect to a MySQL database in Kubernetes.

Options:
  -c <context>      Kubernetes context (default: qa)
  -n <namespace>    Kubernetes namespace (default: kiwios)
  -D <db_name>      Database name
  -u <user>         Database user
  -p <password>     Database password
  -h <host>         Database host (default: 127.0.0.1)
  -P <port>         Database port (default: 3306)
  -e <command>      Execute command instead of interactive shell
  --help            Display this help message
EOF
}

kmysql() {
  emulate -L zsh
  setopt pipefail

  local ctx="qa"
  local ns="kiwios"
  local db_name=""
  local user=""
  local password=""
  local host="127.0.0.1"
  local port="3306"
  local command=""
  local secret_filter=""

  while (( $# )); do
    case "$1" in
      -c) ctx="$2"; shift 2 ;;
      -n) ns="$2"; shift 2 ;;
      -D) db_name="$2"; shift 2 ;;
      -u) user="$2"; shift 2 ;;
      -p) password="$2"; shift 2 ;;
      -h) host="$2"; shift 2 ;;
      -P) port="$2"; shift 2 ;;
      -e) command="$2"; shift 2;;
      --help) _kmysql_usage; return 0 ;;
      *) secret_filter="$1"; shift ;;
    esac
  done

  echo "Using context: $ctx, namespace: $ns"

  if [[ -z "$db_name" ]]; then
    db_name=$(kubectl -n "$ns" --context "$ctx" get sqldatabases -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --prompt="Select a database > " --preview-window=hidden --height 50%)
    if [[ -z "$db_name" ]]; then
      echo "No database selected. Exiting."
      return 1
    fi
  fi

  if [[ -z "$user" ]]; then
    local possible_users=("$db_name" "$db_name-db" "$db_name-user")
    for u in "${possible_users[@]}"; do
      if kubectl -n "$ns" --context "$ctx" get sqluser "$u" &>/dev/null; then
        user="$u"
        break
      fi
    done

    if [[ -z "$user" ]]; then
      user=$(kubectl -n "$ns" --context "$ctx" get sqlusers -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --prompt="Select a user > " --preview-window=hidden --height 50%)
      if [[ -z "$user" ]]; then
        echo "No user selected. Exiting."
        return 1
      fi
    fi
  fi

  local databasePassword
  if [[ -n "$password" ]]; then
    databasePassword="$password"
  else
    local secret_names=("$db_name" "$db_name-secret" "$db_name-mysql")
    local ksecret_name=""
    local secret_data_json=""

    for name in "${secret_names[@]}"; do
      secret_data_json=$(kubectl -n "$ns" --context "$ctx" get secret "$name" -o jsonpath='{.data}' 2>/dev/null)
      if [[ -n "$secret_data_json" ]]; then
        ksecret_name="$name"
        break
      fi
    done

    if [[ -z "$ksecret_name" ]]; then
      echo "Could not find a secret for user '$user'. Tried: ${secret_names[*]}" >&2
      ksecret_name=$(kubectl -n "$ns" --context "$ctx" get secrets -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --prompt="Select a secret > " --preview-window=hidden --height 50%)
      if [[ -z "$ksecret_name" ]]; then
        echo "No secret selected. Exiting."
        return 1
      fi
      secret_data_json=$(kubectl -n "$ns" --context "$ctx" get secret "$ksecret_name" -o jsonpath='{.data}' 2>/dev/null)
    fi
    
    echo "Found secret '$ksecret_name' for user '$user'."

    local encoded_password
    encoded_password=$(echo "$secret_data_json" | jq -r '.databasePassword')

    if [[ -z "$encoded_password" || "$encoded_password" == "null" ]]; then
      encoded_password=$(echo "$secret_data_json" | jq -r '.password')
    fi

    databasePassword=$(echo "$encoded_password" | base64 --decode)
  fi

  local pf_pid
  local deployment_name="$user"
  if ! kubectl -n "$ns" --context "$ctx" get "deployment/$deployment_name" &>/dev/null; then
    deployment_name="$user-service"
    if ! kubectl -n "$ns" --context "$ctx" get "deployment/$deployment_name" &>/dev/null; then
      echo "Error: Could not find deployment for user '$user' (tried '$user' and '$user-service')." >&2
      return 1
    fi
  fi
  
  local local_port=3306
  # Find an available local port starting from 3306
  while lsof -i :$local_port > /dev/null; do
    local_port=$((local_port + 1))
  done

  echo "Forwarding $local_port -> $deployment_name:$port (ns=$ns ctx=$ctx)"
  kubectl -n "$ns" --context "$ctx" port-forward "deployment/$deployment_name" "$local_port:$port" &>/dev/null &
  pf_pid=$!

  # Kill port-forwarding on interrupt.
  trap 'kill $pf_pid 2>/dev/null' INT TERM

  export PYTHONIOENCODING=utf-8

  # Wait a moment for the port-forward to be ready
  sleep 2

  if [[ -n "$command" ]]; then
    mycli -h "$host" -P "$local_port" -u "$user" -p "$databasePassword" -D "$db_name" -e "$command" --csv | nvim -c 'set ft=csv' -
  else
    mycli -h "$host" -P "$local_port" -u "$user" -p "$databasePassword" -D "$db_name"
  fi

  # Clean up the port-forwarding process
  kill $pf_pid 2>/dev/null
}
