FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel

COPY backend/pyproject.toml ./pyproject.toml

# Install dependencies from pyproject.toml without editable mode.
# Use pip-tools or direct pip install with pyproject support.
RUN pip install --no-cache-dir . \
    && pip install --no-cache-dir "uvicorn[standard]>=0.24"

COPY backend . .

ENV PYTHONPATH=/app

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
