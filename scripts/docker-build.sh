#!/bin/bash

set -e  # Зупиняємо виконання при помилці

# 1. Перевірка аргументу
if [ -z "$1" ]; then
  echo "❌ Укажи назву компонента: tests або web"
  exit 1
fi

# Перевірка структури каталогів
if [ ! -d "$ROOT_DIR/.docker/tests" ] || [ ! -d "$ROOT_DIR/.docker/web" ]; then
  echo "❌ Структура .docker/ порушена. Очікується:"
  echo "  .docker/"
  echo "  ├── tests/Dockerfile"
  echo "  └── web/Dockerfile"
  exit 1
fi

COMPONENT="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE_PATH="$ROOT_DIR/.docker/$COMPONENT/Dockerfile"
CONTEXT_PATH="$ROOT_DIR"
IMAGE_NAME="selenide-${COMPONENT}-image"

# 2. Перевірка чи існує Dockerfile
if [ ! -f "$DOCKERFILE_PATH" ]; then
  echo "❌ Dockerfile не знайдено: $DOCKERFILE_PATH"
  exit 1
fi

# 3. Використовуємо Podman
echo "🔨 Створюємо образ '$IMAGE_NAME' з Dockerfile '$DOCKERFILE_PATH'"
podman build -f "$DOCKERFILE_PATH" -t "$IMAGE_NAME" "$CONTEXT_PATH"

echo "✅ Готово. Образ створено: $IMAGE_NAME"