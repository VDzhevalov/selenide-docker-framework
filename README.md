# 📘 README.md
## 🔍 Проєкт: CI для автотестів із Selenide + Allure + Podman
Цей репозиторій містить приклад CI/CD пайплайну для автотестів на Java з використанням:
- Selenide + SeleniumManager
- Podman-контейнерів
- Gradle + JUnit 5
- Allure Reports
- GitHub Actions

### ⚠️ Передумови для локального запуску:
- Встановлений **Podman** (версія ≥ 4.x)
- Встановлена **Java 17+** (тільки якщо запускати тести локально, без контейнера)

## 🧱 Структура
```
/
├── .docker/
│   ├── tests/                 # Dockerfile для запуску тестів
│   │   └── Dockerfile
│   └── web/                   # Dockerfile для веб-сервера Allure
│       └── Dockerfile
├── .github/
│   └── workflows/
│       └── ci.yml
├── src/test/java/ua/kuli/
│   ├── pages/
│   ├── data/
│   └── tests/
├── src/test/resources/
│   └── test-data/games.json
├── build.gradle
├── settings.gradle
├── .gitignore
└── README.md
```

## 🚀 Локальний запуск

> 💡 **Примітка:** `allure-data` — це named volume, який потрібно створити лише один раз. Він зберігається між перезавантаженнями системи і доступний, доки ви самі його не видалите.

Створи named volume:
```bash
podman volume create allure-data
```

### 🧪 Запуск тестів і генерація звіту:

1. Збери образ:
```bash
podman build -t selenide-tests-runner -f .docker/tests/Dockerfile .
```
2. Запуск тестів
```bash
podman run --rm -v allure-data:/app/build/allure-report:Z selenide-tests-runner
```

### 🌐 Запуск веб-сервера для перегляду звіту:
1. Збери образ:
```bash
podman build -t selenide-report-server -f .docker/web/Dockerfile .
```
2. Запусти веб-сервер.
```bash
 podman run -d --name report-server -p 8080:8080 -v allure-data:/app/build/allure-report:Z selenide-report-server
```

3. Відкрий браузер: [http://localhost:8080](http://localhost:8080)

### ⚠️ Якщо хочете запускати тести локально (без використання контейнера) і потім бачити репорти, доведеться примапити теку з репортами до контейнера з вебсервером

Linux / MacOS
```bash
podman run -d --name report-server -p 8080:8080 -v $(pwd)/build/allure-report:/app/build/allure-report:Z selenide-report-server
```
Windows
```bash
podman run -d --name report-server -p 8080:8080 -v ${PWD}/build/allure-report:/app/build/allure-report:Z selenide-report-server
```
---

## 🧪 Приклад параметризованого тесту з JSON

Тести використовують JUnit 5 + Jackson для завантаження даних із `games.json`:

- Клас `GameData` — провайдер, який читає JSON із `src/test/resources/test-data/games.json`
- Метод-постачальник `getDataFromJson()` повертає список `Arguments`
- Тести типу:

```java
    @ParameterizedTest
    @MethodSource("ua.kuli.data.GameData#getDataFromJson")
    void canOpenGamePageAndCheckAllTranslationsButton(String searchQuery, String expectedTitle) {
    mainPage.openMainPage();
    mainPage.searchFor(searchQuery)
            .shouldHaveTitle(expectedTitle)
            .clickOnGame(expectedTitle)
            .shouldHaveShowAllTranslationsButton();
    screenshot();
    }
```

## 🌐 Налаштування GitHub Pages

💡 **Примітка:** Після першого успішного деплою гілка `gh-pages` буде створена автоматично, і ти отримаєш посилання на сайт:
`https://<user>.github.io/<repo>/`

Щоб опублікувати Allure-звіти на GitHub Pages:

1. Перейди в **Settings → Pages** репозиторію
2. В секції **"Build and deployment"**:
  - Source: `Deploy from a branch`
  - Branch: `gh-pages`, Folder: `/ (root)`
3. У **Settings → Actions → General → Workflow permissions**:
  - Увімкни ✅ `Read and write permissions`

## 🤖 CI з GitHub Actions

- Збірка образу
- Запуск тестів у контейнері
- Генерація Allure звіту
- Публікація звіту на GitHub Pages
- Історія запусків та `changelog.html`

### 📥 Перегляд звіту:
- В репозиторії → **Actions** → останній запуск → артефакт `allure-report`
- Або через GitHub Pages:
    - `https://<user>.github.io/<repo>/reports/YYYY-MM-DD/`
    - `https://<user>.github.io/<repo>/changelog.html`
