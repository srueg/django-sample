FROM python:3.7-alpine as builder

WORKDIR /app

RUN apk add --no-cache \
        gcc \
        g++ \
        python3-dev \
        musl-dev \
        postgresql-dev

COPY requirements.txt ./
RUN pip install -r requirements.txt --install-option="--prefix=/app"


FROM python:3.7-alpine

WORKDIR /app

ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache \
        libpq

COPY --from=builder /app /usr/local

COPY ./ .

RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "--config", "gunicorn.py", "mysite.wsgi"]
