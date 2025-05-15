# Образ для запуску тестів і генерації Allure-репорту

FROM docker.io/maven:3.9.4-eclipse-temurin-17 AS runner

USER root

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    tar \
    --no-install-recommends && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    wget -q https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz && \
    tar -xzf allure-2.27.0.tgz && \
    mv allure-2.27.0 /opt/allure && \
    ln -s /opt/allure/bin/allure /usr/bin/allure && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN chmod +x gradlew

RUN ./gradlew clean build -x test
CMD ["sh", "-c", "./gradlew test --continue || true && ./gradlew allureReport"]