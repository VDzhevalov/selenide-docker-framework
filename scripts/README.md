# 📦 scripts/README.md — Документація по скриптам CLI

Цей документ описує bash-скрипти та CLI-утиліту, яка дозволяє будувати Docker-образи та запускати контейнери з будь-якої точки проєкту.

---

## 📁 Структура

```
/scripts
├── README.md              # Це файл, який ви зараз читаєте
├── cli.sh                 # Інтерфейс командного рядка для керування образами/контейнерами
├── docker-build.sh        # Універсальний скрипт для збирання образів (tests/web)

.docker
├── tests/
│   └── Dockerfile         # Dockerfile для тестів
└── web/
    └── Dockerfile         # Dockerfile для веб-сервера Allure
```

> ❗ Структура `.docker/` є обов'язковою — скрипти очікують наявність Dockerfile у відповідних підкаталогах `.docker/tests/` та `.docker/web/`.

---

## ⚙️ `docker-build.sh`

### Призначення

Будує Docker-образ з відповідного Dockerfile (`tests` або `web`), використовуючи корінь проєкту як контекст.

### Використання

```bash
./scripts/docker-build.sh tests
./scripts/docker-build.sh web
```

Це створить образ `selenide-tests-image` або `selenide-web-image` відповідно.

> ⚠️ Скрипт можна запускати з будь-якої директорії, якщо використовувати абсолютний шлях або `cd` в корінь.

---

## 🧠 `cli.sh` — головна CLI-утиліта

### Доступні команди

```bash
./scripts/cli.sh tests create               # Побудувати образ з Dockerfile tests
./scripts/cli.sh tests run ./path/to/save  # Запустити тести з мапінгом репортів у вказану теку

./scripts/cli.sh web create                 # Побудувати образ з Dockerfile web
./scripts/cli.sh web run ./path/to/report  # Запустити веб-сервер і змонтувати репорт
```

> Контейнер з тестами завжди пише Allure-звіт у `/app/build/reports/allure-report`,
> але ви можете вказати будь-яку локальну теку, яка буде туди примаплена.

> ⚠️ Якщо вказана тека для мапінгу не існує, Podman не створить її автоматично й контейнер завершиться з помилкою. Скрипт перевіряє це і створює теку заздалегідь.

### Приклад запуску тестів:

```bash
./scripts/cli.sh tests run ./build/reports/my-custom-report
```

Це запустить контейнер з тестами і змонтує теку `./build/reports/my-custom-report` у `/app/build/reports/allure-report` всередині контейнера. Allure-звіт залишиться на хості.

### Приклад запуску веб-сервера:

```bash
./scripts/cli.sh web run ./build/reports/my-custom-report
```

Це запустить контейнер з образом `selenide-web-image` і покаже Allure-звіт із вказаної директорії.

---

## 🛡 Особливості

* Використовується `podman build` / `podman run`
* SELinux-сумісний (через `:Z` в `-v`)
* Автоматично перевіряється наявність потрібного Dockerfile
* Гнучкий шлях до збереження та перегляду звітів — підходить і для локального запуску, і для CI
* Створює директорію для звітів автоматично, якщо вона відсутня


