# 📘 README.md

## 🔍 Проєкт: CI для автотестів із Selenide + Allure + Podman

Цей репозиторій містить приклад CI/CD пайплайну для автотестів на Java з використанням:

* Selenide + SeleniumManager
* Podman-контейнерів
* Gradle + JUnit 5
* Allure Reports
* GitHub Actions

### ⚠️ Передумови для локального запуску:

* Встановлений **Podman** (версія ≥ 4.x)
* Встановлена **Java 17+** (якщо запускати тести локально, без контейнера)

---

## 🧱 Структура

```
/
├── docs/
│   ├── diagrams.md            # Схеми та ASCII-діаграми процесів
├── .docker/
│   ├── tests/                 # Dockerfile для запуску тестів
│   │   └── Dockerfile
│   └── web/                   # Dockerfile для веб-сервера Allure
│       └── Dockerfile
├── .github/
│   └── workflows/             # Сценарій для GitHub Actions (CI)
│       └── ci.yml
├── scripts/                  # Bash-утиліти для збирання образів і запуску контейнерів
│   ├── cli.sh
│   ├── docker-build.sh
│   └── README.md             # Документація по CLI
├── src/test/java/ua/kuli/    # Тести (демо-приклад пакету)
│   ├── pages/
│   ├── data/
│   └── tests/
├── src/test/resources/       # Тестові ресурси
│   └── test-data/games.json  
├── build.gradle
├── settings.gradle
├── .gitignore
└── README.md
```

> 📄 Опис bash-скриптів і CLI-утиліти доступний в [scripts/README.md](./scripts/README.md)

---

## 🚀 Локальний запуск через CLI

### 1. Побудувати образи

```bash
./scripts/cli.sh tests create
./scripts/cli.sh web create
```

### 2. Запустити тести з вивантаженням репорту

```bash
./scripts/cli.sh tests run ./build/reports/allure-report
```

### 3. Запустити вебсервер для перегляду репорту

```bash
./scripts/cli.sh web run ./build/reports/allure-report
```

Після чого звіт буде доступний за адресою: [http://localhost:8080](http://localhost:8080)

> 📝 Шлях до папки з репортом можна змінювати довільно — головне, щоб він співпадав при запуску тестів і запуску вебсерверу.

---

## 🛠 Альтернатива: запуск вручну без скриптів

> Підходить, якщо хочеш повністю контролювати процес або запускати з CI-пайплайнів вручну.

### 1. Створити named volume

```bash
podman volume create allure-data
```

> 📦 `allure-data` — це named volume, який потрібно створити лише один раз. Він зберігається між перезавантаженнями системи і доступний, доки ви самі його не видалите.

### 2. Зібрати образ для тестів

```bash
podman build -t selenide-tests-image -f .docker/tests/Dockerfile .
```

### 3. Запустити тести з вивантаженням репорту у volume

```bash
podman run --rm \
  -v allure-data:/app/build/reports/allure-report:Z \
  selenide-tests-image
```

Або вивантажити у локальну теку:

```bash
podman run --rm \
  -v $(pwd)/build/reports/allure-report:/app/build/reports/allure-report:Z \
  selenide-tests-image
```

### 4. Зібрати образ для вебсерверу

```bash
podman build -t selenide-web-image -f .docker/web/Dockerfile .
```

### 5. Запустити вебсервер з volume

```bash
podman run -d --name report-server \
  -p 8080:8080 \
  -v allure-data:/app/build/allure-report:Z \
  selenide-web-image
```

Або використати локальну теку:

```bash
podman run -d --name report-server \
  -p 8080:8080 \
  -v $(pwd)/build/reports/allure-report:/app/build/allure-report:Z \
  selenide-web-image
```

### 6. Перейти в браузер:

[http://localhost:8080](http://localhost:8080)

---

## 🧪 Приклад параметизованого тесту з JSON

Тести використовують JUnit 5 + Jackson для завантаження даних із `games.json`:

* Клас `GameData` — провайдер, який читає JSON із `src/test/resources/test-data/games.json`
* Метод-постачальник `getDataFromJson()` повертає список `Arguments`
* Тести типу:

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

---

## 🌐 Налаштування GitHub Pages

> 💡 **Примітка:** Після першого успішного деплою гілка `gh-pages` буде створена автоматично, і ти отримаєш посилання на сайт:
> `https://<user>.github.io/<repo>/`

Щоб опублікувати Allure-звіти на GitHub Pages:

1. Перейди в **Settings → Pages** репозиторію
2. В секції **"Build and deployment"**:

  * Source: `Deploy from a branch`
  * Branch: `gh-pages`, Folder: `/ (root)`
3. У **Settings → Actions → General → Workflow permissions**:

  * Увімкни ✅ `Read and write permissions`

---

## 📊 Діаграми та потоки

Для кращого розуміння структури запуску, CI/CD процесу та взаємодії контейнерів переглянь:
[📄 docs/diagrams.md](./docs/diagrams.md)

---

## 🤖 CI з GitHub Actions

CI автоматично виконує:

* Збірку образу
* Запуск тестів у контейнері
* Генерацію Allure-звіту
* Публікацію звіту на GitHub Pages
* Історію запусків та `changelog.html`

### 📥 Перегляд звіту:

* В репозиторії → **Actions** → останній запуск → артефакт `allure-report`
* Або через GitHub Pages:

  * `https://<user>.github.io/<repo>/reports/YYYY-MM-DD/`
  * `https://<user>.github.io/<repo>/changelog.html`

