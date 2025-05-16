#!/bin/bash

set -e  # Зупиняємо виконання при помилці

# 1. Перевірка аргументу
if [ -z "$1" ]; then
  echo "❌ Укажи назву компонента: tests або web"
  exit 1
fi

COMPONENT="$1"

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Перевірка структури каталогів
if [ ! -d "$PROJECT_ROOT/.docker/tests" ] || [ ! -d "$PROJECT_ROOT/.docker/web" ]; then
  echo "❌ Структура .docker/ порушена. Очікується:"
  echo "  .docker/"
  echo "  ├── tests/Dockerfile"
  echo "  └── web/Dockerfile"
  exit 1
fi

DOCKERFILE_PATH="$PROJECT_ROOT/.docker/$COMPONENT/Dockerfile"
CONTEXT_PATH="$PROJECT_ROOT"
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