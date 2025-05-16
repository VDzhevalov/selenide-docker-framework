#!/bin/bash

set -e

COMMAND="$1"
ACTION="$2"
THIRD_ARG="$3"

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WEB_REPORT_TARGET_PATH="/app/build/allure-report"
TEST_REPORT_TARGET_PATH="/app/build/allure-report"

build_image() {
  COMPONENT="$1"
  DOCKERFILE_PATH="$PROJECT_ROOT/.docker/$COMPONENT/Dockerfile"
  EXPECTED_PATH="$PROJECT_ROOT/.docker/$COMPONENT"

  if [ ! -d "$EXPECTED_PATH" ] || [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Очікується структура: $EXPECTED_PATH/Dockerfile"
    echo "   Але вона не знайдена. Перевір структуру проекту."
    exit 1
  fi

  IMAGE_NAME="selenide-${COMPONENT}-image"

  echo "🔨 Створюємо образ '$IMAGE_NAME' з Dockerfile '$DOCKERFILE_PATH'"
  podman build -f "$DOCKERFILE_PATH" -t "$IMAGE_NAME" "$PROJECT_ROOT"
  echo "✅ Образ зібрано: $IMAGE_NAME"
}

run_web_server() {
  HOST_REPORT_PATH="$1"

  if [ -z "$HOST_REPORT_PATH" ]; then
    echo "❌ Вкажи шлях до папки з Allure-репортом. Наприклад:"
    echo "   ./cli.sh web run ./build/reports/allure-report"
    exit 1
  fi

  if [ ! -d "$HOST_REPORT_PATH" ]; then
    echo "❌ Папка не знайдена: $HOST_REPORT_PATH"
    exit 1
  fi

CONT_NAME="selenide-${COMMAND}-server"

  echo "🚀 Запускаємо вебсервер $CONT_NAME з репортами з: $HOST_REPORT_PATH"
  podman run --rm --name "$CONT_NAME" -d -p 8080:8080 \
    -v "$HOST_REPORT_PATH":"$WEB_REPORT_TARGET_PATH":Z \
    selenide-web-image
}

run_tests_with_report_dir() {
  HOST_REPORT_PATH="$1"

  if [ -z "$HOST_REPORT_PATH" ]; then
    echo "❌ Вкажи шлях до папки, куди зберігати Allure-репорт. Наприклад:"
    echo "   ./cli.sh tests run ./build/reports/allure-report"
    exit 1
  fi

  if [ ! -d "$HOST_REPORT_PATH" ]; then
    echo "📂 Папка не існує. Створюю: $HOST_REPORT_PATH"
    mkdir -p "$HOST_REPORT_PATH"
  fi

  echo "🚀 Запускаємо тести з мапінгом репортів у: $HOST_REPORT_PATH"
  podman run --rm \
    -v "$HOST_REPORT_PATH":"$TEST_REPORT_TARGET_PATH":Z \
    selenide-tests-image
}

case "$COMMAND" in
  web)
    case "$ACTION" in
      create)
        build_image web
        ;;
      run)
        run_web_server "$THIRD_ARG"
        ;;
      *)
        echo "❓ Невідома дія: $ACTION. Доступно: create, run"
        ;;
    esac
    ;;
  tests)
    case "$ACTION" in
      create)
        build_image tests
        ;;
      run)
        run_tests_with_report_dir "$THIRD_ARG"
        ;;
      *)
        echo "❓ Невідома дія: $ACTION. Доступно: create, run"
        ;;
    esac
    ;;
  *)
    echo "❓ Невідома команда: $COMMAND. Доступно: tests, web"
    ;;
esac