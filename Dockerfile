FROM python:3.9-alpine3.19
LABEL maintainer="Benjamin Tinder <benjamintinder76@gmail.com>"

ENV PYJTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install -- upgrade pip && \
    /py/bin/pip install -r /tmp/requirements. txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user