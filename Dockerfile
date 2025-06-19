FROM python:3.13.2-slim

# Переменные окружения
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Установка системных зависимостей
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Установка Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    mv /root/.local/bin/poetry /usr/local/bin/poetry

# Отключаем создание виртуальных окружений
RUN poetry config virtualenvs.create false

# Задаём рабочую директорию
WORKDIR /app

# Копирование файлов конфигурации Poetry
COPY pyproject.toml poetry.lock* /app/

# Установка зависимостей
RUN poetry install --no-root

# Копирование исходного кода проекта
COPY . /app/

# Запуск сервера Django (для production рекомендуется использовать gunicorn)
CMD ["python", "src/manage.py", "runserver", "0.0.0.0:8000"]
