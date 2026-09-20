FROM python:3.12-slim

WORKDIR /app

# Жестко фиксируем глобальный путь к браузерам Playwright для всех пользователей
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Установка системных зависимостей для gcc, psycopg2, Weasyprint и системных библиотек браузеров
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    wget \
    gnupg \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libjpeg62-turbo-dev \
    libpng-dev \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcb1 \
    libxkbcommon0 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libasound2 \
    shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

# Копия только requirements.txt для эффективного кэширования слоёв Docker
COPY requirements.txt .

# Установка всех зависимостей (включая playwright)
RUN pip install --no-cache-dir -r requirements.txt

# Устанавливаем Chromium в нашу фиксированную системную папку /ms-playwright
RUN playwright install chromium

# Копия всего остального кода проекта
COPY . .

# Папка для данных (если бот пишет туда локальные файлы)
RUN mkdir -p /app/data

# Команда запуска для Render
CMD ["python", "run_web.py"]
