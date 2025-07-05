#!/bin/bash

set -euo pipefail

function clean_cache() {
  local path=$1
  if [ -d "$path" ] || [ -f "$path" ]; then
    echo "Удаляю: $path"
    rm -rf "$path"
  else
    echo "Не найден: $path"
  fi
}

echo "Начинаю очистку кешей..."

# Список путей для очистки
declare -a paths=(
  "$HOME/Library/Caches/"
  "$HOME/Library/42_cache"
  "$HOME/Library/Application Support/Slack/Service Worker/CacheStorage/"
  "$HOME/Library/Application Support/Slack/Cache/"
  "$HOME/Library/Application Support/Slack/Code Cache/"
  "$HOME/Library/Application Code/Cache/"
  "$HOME/Library/Application Code/CachedData/"
  "$HOME/Library/Group Containers/6N38VWS5BX.ru.keepcoder.Telegram/account-570841890615083515/postbox/"
  "$HOME/Library/Application Support/Code/Cache"
  "$HOME/Library/Application Support/Code/CachedData"
  "$HOME/Library/Application Support/Code/CachedExtension"
  "$HOME/Library/Application Support/Code/CachedExtensions"
  "$HOME/Library/Application Support/Code/CachedExtensionVSIXs"
  "$HOME/Library/Application Support/Code/Code Cache"
  "$HOME/Library/Application Support/Code/User/workspaceStorage"
)

for path in "${paths[@]}"; do
  clean_cache "$path"
done

echo "Очистка кешей завершена!"

# Очистить терминал
printf "\033c"
