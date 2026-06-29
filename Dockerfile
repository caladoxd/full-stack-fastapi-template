FROM python:3.14-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY backend ./backend

RUN pip install --no-cache-dir pip-tools && \
    pip install --no-cache-dir -e ./backend && \
    pip install --no-cache-dir "uvicorn[standard]>=0.24"

WORKDIR /app/backend
ENV PYTHONPATH=/app/backend

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
