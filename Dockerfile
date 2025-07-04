# FROM python:3.9-slim
# LABEL maintainer="Benjamin Tinder <benjamintinder76@gmail.com>"

# ENV PYTHONUNBUFFERED=1

# COPY ./requirements.txt /tmp/requirements.txt
# COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# COPY ./app /app
# WORKDIR /app
# EXPOSE 8000

# ARG DEV=false
# RUN python -m venv /py && \
#     /py/bin/pip install --upgrade pip && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     /py/bin/pip install black && \
#     /py/bin/pip install isort && \
#     if [ $DEV = "true" ]; \
#         then /py/bin/pip install -r /tmp/requirements.dev.txt; \
#     fi && \
#     rm -rf /tmp && \
#     adduser \
#         --disabled-password \
#         --home /home/django-user \
#         --gecos "" \
#         django-user && \
#     # mkdir -p /home/django-user/.cache && \
#     chown -R django-user:django-user /home/django-user && \
#     chown -R django-user:django-user /app && \
#     chmod -R 755 /app && \
#     chmod -R 755 /py

# ENV PATH="/py/bin:$PATH"

# USER django-user


FROM python:3.9-slim-bullseye

# Ensure all system packages are up to date to reduce vulnerabilities
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="Benjamin Tinder <benjamintinder76@gmail.com>"

# Системные зависимости
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Создание виртуального окружения
RUN python -m venv /py

# Обновление pip и установка зависимостей
COPY ./requirements.txt /tmp/requirements.txt
RUN /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    /py/bin/pip install black && \
    /py/bin/pip install isort && \
    /py/bin/pip install flake8 && \
    # chown -R django-user:django-user /py && \
    rm -rf /tmp/requirements.txt

# Создание пользователя
RUN useradd -ms /bin/bash django-user

# Настройка рабочей директории
WORKDIR /home/django-user/app
COPY ./app /home/django-user/app
RUN chown -R django-user:django-user /home/django-user

ENV PATH="/py/bin:$PATH"

USER django-user

EXPOSE 8000
