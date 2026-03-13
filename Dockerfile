FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    libsox-dev \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu

WORKDIR /app

COPY pyproject.toml setup.cfg ./
COPY wyoming_kokoro_torch ./wyoming_kokoro_torch

RUN pip install --no-cache-dir .

RUN mkdir -p /app/data

CMD ["python", "-m", "wyoming_kokoro_torch", \
     "--voice", "af_heart", \
     "--uri", "tcp://0.0.0.0:10200", \
     "--data-dir", "/app/data", \
     "--download-dir", "/app/data"]