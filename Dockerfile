########################################################
# Stage 1: Install dependencies with uv and copy to /opt/python
########################################################
FROM python:3.12-slim AS deps

# Avoid prompts & keep images small
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

ARG APP_ROOT="/app"
WORKDIR ${APP_ROOT}

# Bring in lockfiles first for better caching
COPY pyproject.toml ${APP_ROOT}/
COPY uv.lock ${APP_ROOT}/

# Install uv and create a local venv, then sync (no dev deps)
RUN pip install --no-cache-dir uv
RUN uv sync

# Materialize a Lambda-style "layer" dir with only runtime packages
# (Lambda adds /opt/python to sys.path automatically)
RUN mkdir -p /opt/python
RUN cp -a ${APP_ROOT}/.venv/lib/python3.12/site-packages/. /opt/python/


########################################################
# Stage 2: Create final AWS Lambda image
########################################################
#FROM public.ecr.aws/lambda/python:3.12-arm64
FROM public.ecr.aws/lambda/python:3.12

ARG APP_NAME
ARG APP_VERSION
ARG COMMIT_SHA
ARG BRANCH
ARG BUILD_DATE

ENV APP_NAME="${APP_NAME}"
ENV APP_VERSION="${APP_VERSION}"
ENV COMMIT_SHA="${COMMIT_SHA}"
ENV BRANCH="${BRANCH}"
ENV BUILD_DATE="${BUILD_DATE}"

LABEL org.opencontainers.image.name="${APP_NAME}" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.revision="${COMMIT_SHA}" \
      org.opencontainers.image.ref.branch="${BRANCH}" \
      org.opencontainers.image.created="${BUILD_DATE}"

# This image automatically adds packages in /opt/python to sys.path
COPY --from=deps /opt/python /opt/python
COPY src/ ${LAMBDA_TASK_ROOT}/

ENV _HANDLER="main.handler"
CMD ["main.handler"]
