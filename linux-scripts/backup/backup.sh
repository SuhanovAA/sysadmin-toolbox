#!/bin/bash

# === Настройки ===
SRC_DIR="/home/s3585592/data"
BACKUP_DIR="/home/s3585592/backups"
SERVER_USER="s3585592"
SERVER_HOST="10.11.0.150"
SERVER_PATH="/path/to/backup/directory"
SSH_KEY="/home/s3585592/.ssh/backup_key"

# === Создание папки для архива ===
mkdir -p "$BACKUP_DIR"

# === Функция архивирования ===
archive_folder() {
    local archive_name="$BACKUP_DIR/backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
    tar -czf "$archive_name" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
    echo "$archive_name"
}
# === Функция копирования архива на сервер ===
copy_to_server() {
    local file_to_copy="$1"

    # Проверка доступности сервера
    if ping -c 1 "$SERVER_HOST" &> /dev/null; then
        echo "Сервер доступен, копирую..."
        echo "Выполняю: scp -i \"$SSH_KEY\" \"$file_to_copy\" \"$SERVER_USER@$SERVER_HOST:$SERVER_PATH\""

        # Копирование архива
        scp -i "$SSH_KEY" "$file_to_copy" "$SERVER_USER@$SERVER_HOST:$SERVER_PATH"
        if [ $? -eq 0 ]; then
            echo "Архив успешно скопирован на сервер!"
        else
            echo "Ошибка при копировании архива!"
        fi
    else
        echo "Сервер недоступен!"
    fi
}

# === Основной блок ===
archive_file=$(archive_folder)
copy_to_server "$archive_file"
