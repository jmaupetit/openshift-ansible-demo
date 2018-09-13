FROM python:3.6-alpine as base

# ---- build ----
FROM base as builder

WORKDIR /builder

COPY requirements/base.txt /builder/requirements.txt

RUN mkdir /install && \
    pip install --prefix=/install -r requirements.txt

# ---- final application image ----
FROM base

# Copy installed python dependencies
COPY --from=builder /install /usr/local

# Copy application (see .dockerignore)
COPY ./yolo /app/yolo

WORKDIR /app

# Un-privileged user running the application
USER 10000

# Run the app
CMD gunicorn -w 4 -b 0.0.0.0:8080 yolo.index:app
