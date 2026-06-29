FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel

# Copy the entire backend directory so pyproject.toml's build backend
# can inspect the source tree (app/ or src/) during metadata generation.
COPY backend/ .

# Install the project and uvicorn.
# Non-editable install resolves dependencies from pyproject.toml.
RUN pip install --no-cache-dir . \
    && pip install --no-cache-dir "uvicorn[standard]>=0.24"

ENV PYTHONPATH=/app

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
