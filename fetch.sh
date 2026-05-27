#!/bin/bash
set -euo pipefail

# Локальный скрипт для выборки конфигов
# Использование: ./fetch.sh <url> <количество> <имя_файла> [протоколы...]
# Пример: ./fetch.sh "https://example.com/list.txt" 20 output.txt vless vmess

if [ $# -lt 3 ]; then
  echo "Использование: $0 <url> <количество> <имя_файла> [протоколы...]"
  echo "Пример:       $0 'https://example.com/list.txt' 20 output.txt vless vmess"
  exit 1
fi

URL="$1"
COUNT="$2"
FILENAME="$3"
shift 3
PROTOCOLS=("$@")
OUTDIR="configs"

# Если протоколы не указаны — по умолчанию vless
if [ ${#PROTOCOLS[@]} -eq 0 ]; then
  PROTOCOLS=("vless")
fi

# Строим grep-паттерн: ^(vless|vmess|trojan)://
GREP_PATTERN="^$(IFS='|'; echo "${PROTOCOLS[*]}")://"

mkdir -p "$OUTDIR"

echo "Загрузка из: $URL"
echo "Количество:  $COUNT"
echo "Файл:        $OUTDIR/$FILENAME"
echo "Протоколы:   ${PROTOCOLS[*]}"

curl -sL "$URL" | grep -E "$GREP_PATTERN" | head -n "$COUNT" > "$OUTDIR/$FILENAME"

LINES=$(wc -l < "$OUTDIR/$FILENAME")
echo "Сохранено:   $LINES конфигов"
