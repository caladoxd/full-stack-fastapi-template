FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY backend/pyproject.toml ./pyproject.toml

# Copy poetry.lock if it exists; if not, proceed without it
# (Docker doesn't support conditional COPY, so we install without it)

# Install poetry and dependencies from pyproject.toml
RUN pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi \
    && pip install --no-cache-dir "uvicorn[standard]>=0.24"

COPY backend/ .

WORKDIR /app
ENV PYTHONPATH=/app

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
