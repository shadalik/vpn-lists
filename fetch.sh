#!/bin/bash
set -euo pipefail

# Локальный скрипт для выборки конфигов
# Использование: ./fetch.sh <url> <количество> <имя_файла>
# Пример: ./fetch.sh "https://example.com/list.txt" 20 output.txt

if [ $# -lt 3 ]; then
  echo "Использование: $0 <url> <количество> <имя_файла>"
  echo "Пример:       $0 'https://example.com/list.txt' 20 output.txt"
  exit 1
fi

URL="$1"
COUNT="$2"
FILENAME="$3"
OUTDIR="configs"

mkdir -p "$OUTDIR"

echo "Загрузка из: $URL"
echo "Количество:  $COUNT"
echo "Файл:        $OUTDIR/$FILENAME"

curl -sL "$URL" | grep '^vless://' | head -n "$COUNT" > "$OUTDIR/$FILENAME"

LINES=$(wc -l < "$OUTDIR/$FILENAME")
echo "Сохранено:   $LINES конфигов"
